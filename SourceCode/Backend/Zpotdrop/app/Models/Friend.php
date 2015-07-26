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

namespace App\Models;

/**
 * App\Models\Friend
 *
 * @SWG\Model (
 *    id="Friend",
 * 	@SWG\Property(name="id", type="integer", required=true),
 * 	@SWG\Property(name="user_id", type="integer", required=true),
 * 	@SWG\Property(name="friend_id", type="integer", required=true),
 *  @SWG\Property(name="is_friend", type="integer", description="not friend: 0, friend: 1"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
 * @property integer $user_id
 * @property integer $friend_id
 * @property boolean $is_friend
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @property-read \App\Models\User $user
 * @property-read \App\Models\User $friend
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Friend whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Friend whereFriendId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Friend whereIsFriend($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Friend whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\Friend whereUpdatedAt($value)
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
	protected $hidden = [];

	/*Friend Flag*/
	const FRIEND_YES    = 1;
	const FRIEND_NO     = 0;

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Models\User', 'user_id');
	}

	public function friend(){
		return $this->belongsTo('App\Models\User', 'friend_id');
	}
}
