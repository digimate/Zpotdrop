<?php
/*
|--------------------------------------------------------------------------
| Comments.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 9:37 PM
*/

namespace App\Acme\Models;


/**
 * App\Models\Comment
 *
 * @property integer $user_id
 * @property integer $post_id
 * @property string $message
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @property-read \App\Models\User $user
 * @property-read \App\Models\Post $post
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Comment whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Comment wherePostId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Comment whereMessage($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Comment whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Comment whereUpdatedAt($value)
 *
 */
class Comment extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'comments';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'user_id',
		'post_id',
		'message'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['deleted_at', 'updated_at'];


	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	public function post(){
		return $this->belongsTo('App\Acme\Models\Post', 'post_id');
	}


    /**
     * @param $postId
     * @param $page
     * @param $limit
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public static function getCommentsOfPost($postId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);


        return Comment::with(['user' => function($query) {
            $query->addSelect(['id', 'avatar', 'first_name', 'last_name']);
            $query->orderBy('follower_count', 'desc');
            $query->orderBy('first_name', 'asc');
            $query->orderBy('id', 'asc');
        }])
            ->where('post_id', $postId)
            ->paginate($limit, ['*'], 'page', $page);
    }
}