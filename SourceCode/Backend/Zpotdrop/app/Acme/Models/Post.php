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
use app\Acme\Collections\ElasticCollection;
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
     * parent key for elastic document
     */
    protected $parentKey = 'user_id';
    public function getParentKey() {
        return $this->parentKey;
    }

    /**
     * elasticsearch mapping
     * @var array
     */
    protected $mappingProperties = array(
        'id' => [
            'type' => 'long',
            'analyzer' => 'standard'
        ],
        'status' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        "geo_point" => [
            "type" => "geo_point",
            "analyzer" => "stop",
            "stopwords" => [","]
        ],
        'lat' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'long' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'user_id' => [
           'type' => 'string',
            'analyzer' => 'standard'
        ],
        'location_id' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'with_tags' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'likes_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'comments_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'cmin_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'created_at' => [
            'type' => 'string'
        ]
    );
    public function documentFields()
    {
        return [
            'geo_point' => $this->lat . ", " . $this->long,
            'user_id' => $this->user_id,
            'id' => $this->id,
            'status' => $this->status,
            'lat' => $this->lat,
            'long' => $this->long,
            'location_id' => $this->location_id,
            'with_tags' => $this->with_tags,
            'likes_count' => $this->likes_count,
            'comments_count' => $this->comments_count,
            'cmin_count' => $this->cmin_count,
            'created_at' => $this->created_at
        ];
    }

    /**
     * Puts mappings.
     *
     * @return array
     */
    public static function putMapping()
    {
        $instance = new static;
        $mapping = $instance->basicElasticParams();
        $params = array(
            '_source'       => array('enabled' => true),
            'properties'    => $instance->getMappingProperties()
        );

        $mapping['body'][$instance->getTypeName()] = $params;
        $mapping['body']['posts']['_parent'] = [
            'type' => 'users'
        ];
        $mapping['body']['posts']['_routing'] = [
            'required' => false,
            'path' => 'user_id'
        ];
        return $instance->getElasticClient()->indices()->putMapping($mapping);
    }
    /**
     * Indexes the model in Elasticsearch.
     *
     * @return array
     */
    public function index()
    {//die('aaaa');
        $params = $this->basicElasticParams(true);
        $params['body'] = $this->documentFields();
        $params['parent'] = (string)$params['body']['user_id'];

        return $this->getElasticClient()->index($params);
    }

    /**
     * Create a new CustomBouncyCollection instance.
     * @param array $models
     * @return CustomBouncyCollection
     */
    public function newCollection(array $models = [])
    {
        return new ElasticCollection($models);
    }

    /**
     * Save the model to the database.
     * neu override save, can phai override ke thua ham save trong BouncyTrait
     * @param  array  $options
     * @return bool
     */
    /*public function save(array $options = [])
    {
        return parent::save($options);
    }*/


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


    /**
     * get feeds from following
     * @param $userId
     * @param $page
     * @param $limit
     * @return array
     */
    public static function getNewFeeds($userId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);

        $friends = Friend::where('user_id', $userId)->where('is_friend', '>=', Friend::FRIEND_FOLLOW)->lists('is_friend', 'friend_id');
        // array([friend_id => is_friend])
        $friends = $friends->toArray();
        $posts = Post::with(['user' => function($query) {
            $query->addSelect(['id', 'avatar', 'first_name', 'last_name', 'is_private']);
        }, 'location' => function($query) {

        }])
            ->whereIn('user_id', array_merge(array_keys($friends), [$userId]) )
            ->orderBy('created_at', 'desc')
            ->paginate($limit, ['*'], 'page', $page);
        return ['posts' => $posts, 'friends' => $friends];
    }
}