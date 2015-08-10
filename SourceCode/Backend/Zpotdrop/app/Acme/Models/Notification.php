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

namespace App\Acme\Models;


/**
 * App\Models\Like
 *
 * @property integer $user_id
 * @property integer $friend_id
 * @property integer $message
 * @property integer $post_id
 * @property integer $action_type
 * @property integer $is_read
 * @property string $deleted_at
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @property-read \App\Models\User $user
 * @property-read \App\Models\Post $post
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereFriendId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereMessage($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like wherePostId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereActionType($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereIsRead($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereDeletedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Like whereUpdatedAt($value)
 * @SWG\Model (
 *    id="Like",
 * 	@SWG\Property(name="user_id", type="integer", required=true),
 * 	@SWG\Property(name="friend_id", type="integer", required=true),
 * 	@SWG\Property(name="message", type="integer", required=true),
 * 	@SWG\Property(name="post_id", type="integer", required=true),
 *  @SWG\Property(name="deleted_at", type="string",format="datetime"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
 */
class Notification extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'notifications';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'user_id',
		'friend_id',
		'post_id',
		'message',
		'action_type',
		'is_read'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['user_id', 'friend_id', 'post_id', 'deleted_at'];

	const IS_READ           = 1;
	const IS_UNREAD         = 0;

	const ACTION_TYPE_COMING    = 0;
	const ACTION_TYPE_COMMENT   = 1;
	const ACTION_TYPE_LIKE      = 2;
	const ACTION_TYPE_FOLLOWING = 3;

	public static $action_messages = [
		self::ACTION_TYPE_COMING    => 'Is coming to your zpotdrop',
		self::ACTION_TYPE_COMMENT   => 'Commented on your zpotdrop: %s',
		self::ACTION_TYPE_LIKE      => 'Liked your zpotdrop',
		self::ACTION_TYPE_FOLLOWING => 'Started following you'
	];

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	public function post(){
		return $this->belongsTo('App\Acme\Models\Post', 'post_id');
	}

	public function friend()
	{
		return $this->belongsTo('App\Acme\Models\User', 'friend_id');
	}
}