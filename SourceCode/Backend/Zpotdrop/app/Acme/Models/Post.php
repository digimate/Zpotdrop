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
 * @property-read \App\Models\User $user
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Comment[] $comments
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Like[] $likes
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereStatus($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereVenueId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereLikesCount($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereCommentsCount($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereDeletedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Post whereUpdatedAt($value)
 * @SWG\Model (
 *    id="Post",
 * 	@SWG\Property(name="id", type="integer", required=true),
 * 	@SWG\Property(name="status", type="string", required=true),
 * 	@SWG\Property(name="venue_id", type="integer", required=true),
 * 	@SWG\Property(name="user_id", type="integer"),
 * 	@SWG\Property(name="likes_count", type="integer"),
 * 	@SWG\Property(name="comments_count", type="integer"),
 *  @SWG\Property(name="deleted_at", type="string",format="datetime"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
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
		'venue_id',
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
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	/*Relations*/
	/**
	 * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
	 */
	public function venue(){
		return $this->belongsTo('App\Acme\Models\Venue', 'venue_id');
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