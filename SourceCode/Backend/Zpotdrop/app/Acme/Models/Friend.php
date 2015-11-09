<?php
/*
|--------------------------------------------------------------------------
| BaseModel.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 1:32 PM
*/

namespace App\Acme\Models;

/**
 * App\Models\Friend
 *
 * @property integer $user_id
 * @property integer $friend_id
 * @property boolean $is_friend
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 */
class Friend extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'friends';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = ['user_id', 'friend_id', 'is_friend'];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['created_at', 'user_id', 'friend_id'];

	/*Friend Flag*/
	const FRIEND_YES    = 2;
    const FRIEND_FOLLOW = 1;
	const FRIEND_REQUEST     = 0;
    const FRIEND_NO = -1;

    public static function getFriendStatusText($status) {
        $text = '';
        switch($status) {
            case self::FRIEND_NO:
                $text = 'No';
                break;
            case self::FRIEND_REQUEST:
                $text = 'Request';
                break;
            case self::FRIEND_FOLLOW:
                $text = 'Following';
                break;
            case self::FRIEND_YES:
                $text = 'Friend';
                break;
        }
        return $text;
    }

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id', 'id');
	}

	public function friend(){
		return $this->belongsTo('App\Acme\Models\User', 'friend_id');
	}


    /**
     * get followers
     * @param $userId
     * @param $page
     * @param $limit
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public static function getFollowers($userId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);

        return Friend::with(['user' => function($query) {
                    $query->addSelect(['id', 'avatar', 'first_name', 'last_name']);
                    $query->orderBy('follower_count', 'desc');
                    $query->orderBy('first_name', 'asc');
                    $query->orderBy('id', 'asc');
                }])
            ->where('friend_id', $userId)->where('is_friend', '>=', Friend::FRIEND_FOLLOW)
            ->paginate($limit, ['*'], 'page', $page);
    }

    /**
     * get followings
     * @param $userId
     * @param $page
     * @param $limit
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public static function getFollowings($userId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);

        return Friend::with(['friend' => function($query) {
            $query->addSelect(['id', 'avatar', 'first_name', 'last_name']);
            $query->orderBy('follower_count', 'desc');
            $query->orderBy('first_name', 'asc');
            $query->orderBy('id', 'asc');
        }])
            ->where('user_id', $userId)->where('is_friend', '>=', Friend::FRIEND_FOLLOW)
            ->paginate($limit, ['*'], 'page', $page);
    }


    /**
     * @param $userId
     * @param $keyword
     * @param $page
     * @param $limit
     * @return \Fadion\Bouncy\ElasticCollection
     */
    public static function getFriends($userId, $keyword, &$page, &$limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);
        $offset = ($page - 1) * $limit;

        $friendIds = Friend::where('user_id', $userId)->where('is_friend', Friend::FRIEND_YES)->lists('friend_id');
        $params = [
            //"_source" => ["id", "avatar", 'is_private'],
            'query' => [
                "filtered" => [
                    'filter' => [
                        'terms' => [
                            "id" => $friendIds
                        ]
                    ],
                ]
            ],
            "sort" => [
                ['follower_count' => ['order' => 'desc']]
            ],
            'from' => $offset,
            'size' => $limit
        ];

        if (!empty($keyword)) {
            $params['query']['filtered']['query'] = [
                'multi_match' => [
                    'query' => $keyword,
                    'fields' => ['username'],
                    "fuzziness" => "AUTO"
                ]
                /*'fuzzy' => array(
                    'name' => array(
                        'value' => $keyword,
                        'fuzziness' => 0
                    )
                )*/
            ];
        }

        $results = User::search($params);
        return $results;
    }


    /**
     * Scan zpot
     * @param $userId
     * @param $keyword
     * @param $page
     * @param $limit
     * @return \Fadion\Bouncy\ElasticCollection
     */
    public static function scan($userId, $lat, $long, $distance) {

        $friendIds = Friend::where('user_id', $userId)->where('is_friend', Friend::FRIEND_YES)->lists('friend_id');
        $params = [
            "_source" => ["id", "first_name", "last_name", 'device_id', 'device_type'],
            'query' => [
                "filtered" => [
                    'query' => [
                        'terms' => [
                            "id" => $friendIds
                        ]
                    ],
                    'filter' => [
                        'geo_distance' => [
                            "distance" => "{$distance}km",
                            "geo_point" => [
                                'lat' => $lat,
                                'lon' => $long
                            ]
                        ],
                    ],
                ]
            ],
            "sort" => [[
                "_geo_distance" => [
                    "geo_point" => [
                        "lat" =>  $lat,
                        "lon" => $long
                    ],
                    "order" =>         "asc",
                    "unit" =>          "km",
                    "distance_type" => "plane"
                ]
            ]],
        ];

        $results = User::search($params);
        return $results;
    }


    public static function zpotAll($userId) {
        $friendIds = Friend::where('user_id', $userId)->where('is_friend', Friend::FRIEND_YES)->lists('friend_id');
        //$user
    }

}
