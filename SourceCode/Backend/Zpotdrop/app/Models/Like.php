<?php
/*
|--------------------------------------------------------------------------
| Like.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 9:37 PM
*/

namespace App\Models;


/**
 * App\Models\Like
 *
 * @property integer $user_id 
 * @property integer $post_id 
 * @property string $deleted_at 
 * @property \Carbon\Carbon $created_at 
 * @property \Carbon\Carbon $updated_at 
 * @property-read \App\Models\User $user 
 * @property-read \App\Models\Post $post 
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like wherePostId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereDeletedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereUpdatedAt($value)
 *
 * @SWG\Model (
 *    id="Like",
 * 	@SWG\Property(name="user_id", type="integer", required=true),
 * 	@SWG\Property(name="post_id", type="integer", required=true),
 *  @SWG\Property(name="deleted_at", type="string",format="datetime"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
 */
class Like extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'likes';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'user_id',
		'post_id'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['user_id', 'post_id', 'deleted_at'];

	/**
	 * Finish processing on a successful save operation.
	 *
	 * @param  array $options
	 * @return void
	 */
	protected function finishSave(array $options)
	{
		/*get post and make like ++*/
		$post = new Post();
		$post->makeLike($this->getAttribute('post_id'));
	}

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Models\User', 'user_id');
	}

	public function post(){
		return $this->belongsTo('App\Models\Post', 'post_id');
	}
}