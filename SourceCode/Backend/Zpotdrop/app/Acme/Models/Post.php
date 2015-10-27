<?php
/*
|--------------------------------------------------------------------------
| Post.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 8:56 PM
*/

namespace App\Acme\Models;
use Fadion\Bouncy\BouncyTrait;

/**
 * Class Post
 *
 * @package App\Models
 * @property integer $id
 * @property string $status
 * @property string $venue_id
 * @property integer $user_id
 * @property integer $likes_count
 * @property integer $comments_count
 * @property string $deleted_at
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 *
 */
class Post extends BaseModel
{
    use BouncyTrait;
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'posts';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'status',
		'location_id',
		'user_id',
		'likes_count',
		'comments_count',
        'cmin_count',
        'lat',
        'long',
        'with_tags'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['geo_point','deleted_at'];

    public static $rule = [
        'content'       => 'required|max:255',
        'lat'           => 'required|numeric',
        'long'          => 'required|numeric',
        'location_id'   => 'numeric|min:1',
    ];

    /**
     * elasticsearch mapping
     * @var array
     */
    protected $mappingProperties = array(
        "geo_point" => [
            "type" => "geo_point",
            "analyzer" => "stop",
            "stopwords" => [","]
        ]
    );

    /**
     * Save the model to the database.
     *
     * @param  array  $options
     * @return bool
     */
    public function save(array $options = [])
    {
        $this->setAttribute('geo_point', "{$this->getAttribute('lat')}, {$this->getAttribute('long')}" );
        return parent::save($options);
    }


	/*Relations*/
	/**
	 * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
	 */
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	/*Relations*/
	/**
	 * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
	 */
	public function location(){
		return $this->belongsTo('App\Acme\Models\Location', 'location_id');
	}

	/**
	 * @return \Illuminate\Database\Eloquent\Relations\HasMany
	 */
	public function comments()
	{
		return $this->hasMany('App\Acme\Models\Comment', 'post_id');
	}

	/**
	 * @return \Illuminate\Database\Eloquent\Relations\HasMany
	 */
	public function likes()
	{
		return $this->hasMany('App\Acme\Models\Like', 'post_id');
	}


    public static function getNewFeeds($userId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);

        $friends = Friend::where('user_id', $userId)->lists('is_friend', 'friend_id'); // array([friend_id => is_friend])
        $friends = $friends->toArray();

        $posts = Post::with(['user' => function($query) {
            $query->addSelect(['id', 'avatar', 'first_name', 'last_name']);
        }, 'location' => function($query) {

        }])
            ->whereIn('user_id', array_keys($friends))
            ->orderBy('created_at', 'desc')
            ->paginate($limit, ['*'], 'page', $page);
        return ['posts' => $posts, 'friends' => $friends];
    }
}