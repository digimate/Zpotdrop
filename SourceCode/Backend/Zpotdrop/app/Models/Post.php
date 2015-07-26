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

namespace App\Models;

/**
 * App\Models\Post
 *
 * @property integer $id 
 * @property string $status 
 * @property string $venue_name 
 * @property float $venue_lat 
 * @property float $venue_long 
 * @property integer $user_id 
 * @property integer $likes_count
 * @property integer $comments_count
 * @property string $deleted_at 
 * @property \Carbon\Carbon $created_at 
 * @property \Carbon\Carbon $updated_at 
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereStatus($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereVenueName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereVenueLat($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereVenueLong($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereLikesCount($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereCommentsCount($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereDeletedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereUpdatedAt($value)
 */
/**
 * Class Post
 * @package App\Models
 */
class Post extends BaseModel
{
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
		'venue_name',
		'venue_lat',
		'venue_long',
		'user_id',
		'likes',
		'comments'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['user_id', 'post_id', 'deleted_at'];

	/*Relations*/
	/**
	 * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
	 */
	public function user(){
		return $this->belongsTo('App\Models\User');
	}

	/**
	 * @return \Illuminate\Database\Eloquent\Relations\HasMany
	 */
	public function comments()
	{
		return $this->hasMany('App\Models\Comment', 'post_id');
	}

	/**
	 * @return \Illuminate\Database\Eloquent\Relations\HasMany
	 */
	public function likes()
	{
		return $this->hasMany('App\Models\Like', 'post_id');
	}

	/*Repository*/
	/**
	 * @param $id
	 */
	public function makeLike($id)
	{
		$post = Post::find($id);
		if($post){
			$post->likes_count += 1;
			$post->save();
		}
	}

	/**
	 * @param $id
	 */
	public function makeComment($id)
	{
		$post = Post::find($id);
		if($post){
			$post->comments_count += 1;
			$post->save();
		}
	}
}