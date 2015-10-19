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
	protected $hidden = ['user_id', 'friend_id'];

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
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	public function friend(){
		return $this->belongsTo('App\Acme\Models\User', 'friend_id');
	}
}
