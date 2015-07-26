<?php

namespace App\Models;

use App\Models\BaseModel;

/**
 * App\Friend
 *
 * @property integer $id
 * @property integer $user_id
 * @property integer $friend_id
 * @property boolean $is_friend
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereFriendId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereIsFriend($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Friend whereUpdatedAt($value)
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
