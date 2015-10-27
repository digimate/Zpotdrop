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
}
