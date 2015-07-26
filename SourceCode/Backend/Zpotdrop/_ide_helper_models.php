<?php
/**
 * An helper file for your Eloquent Models
 * Copy the phpDocs from this file to the correct Model,
 * And remove them from this file, to prevent double declarations.
 *
 * @author Barry vd. Heuvel <barryvdh@gmail.com>
 */


namespace App\Models{
/**
 * App\Models\BaseModel
 *
 */
	class BaseModel {}
}

namespace App\Models{
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
	class Friend {}
}

namespace App\Models{
/**
 * App\Models\User
 *
 * @SWG\Model (
 *    id="User",
 * 	@SWG\Property(name="id", type="integer", required=true),
 * 	@SWG\Property(name="email", type="string", required=true),
 * 	@SWG\Property(name="password", type="string", required=true),
 *  @SWG\Property(name="avatar", type="string"),
 * 	@SWG\Property(name="first_name", type="string", required=true),
 * 	@SWG\Property(name="last_name", type="string"),
 * 	@SWG\Property(name="phone_number", type="string"),
 * 	@SWG\Property(name="home_town", type="string"),
 *  @SWG\Property(name="birthday", type="string", format="date"),
 *  @SWG\Property(name="is_private", type="boolean"),
 *  @SWG\Property(name="is_enable_all_zpot", type="boolean"),
 *  @SWG\Property(name="lat", type="float"),
 *  @SWG\Property(name="long", type="float"),
 *  @SWG\Property(name="status", type="integer", description="1: active, 0: inactive"),
 *  @SWG\Property(name="device_id", type="string"),
 *  @SWG\Property(name="device_name", type="string"),
 *  @SWG\Property(name="device_type", type="integer"),
 *  @SWG\Property(name="remember_token", type="string"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
 * @property integer $id
 * @property string $email
 * @property string $password
 * @property string $avatar
 * @property string $first_name
 * @property string $last_name
 * @property string $phone_number
 * @property string $home_town
 * @property boolean $age
 * @property boolean $is_private
 * @property boolean $is_enable_all_zpot
 * @property float $lat
 * @property float $long
 * @property boolean $status
 * @property string $device_id
 * @property string $device_name
 * @property boolean $device_type
 * @property string $remember_token
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereEmail($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User wherePassword($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereAvatar($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereFirstName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereLastName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User wherePhoneNumber($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereHomeTown($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereAge($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereIsPrivate($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereIsEnableAllZpot($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereLat($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereLong($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereStatus($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereDeviceId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereDeviceName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereDeviceType($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereRememberToken($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereUpdatedAt($value)
 */
	class User {}
}

