<?php

namespace App\Acme\Models;

use Carbon\Carbon;
use Illuminate\Auth\Authenticatable;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;
use Hashids;
use Vinkla\Hashids\HashidsServiceProvider;

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
 * 	@SWG\Property(name="hash", type="string"),
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
 * @property string $hash
 * @property string $phone_number
 * @property string $home_town
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
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereHash($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User wherePhoneNumber($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereHomeTown($value)
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
 * @property string $birthday
 * @method static \Illuminate\Database\Query\Builder|\App\Models\User whereBirthday($value)
 * @property boolean $gender 
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\User whereGender($value)
 */
class User extends BaseModel implements AuthenticatableContract, CanResetPasswordContract
{
	use Authenticatable, CanResetPassword;

	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'users';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'email',
		'password',
		'avatar',
		'first_name',
		'last_name',
		'phone_number',
		'home_town',
		'birthday',
		'is_private',
		'is_enable_all_zpot',
		'lat',
		'long',
		'status',
		'device_id',
		'device_name',
		'device_type'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['password', 'remember_token'];

	/*
	 * Status of user
	 * @default: 1: active
	 * 0: inactive
	 */
	const STATUS_ACTIVE     = 1;
	const STATUS_INACTIVE   = 0;

	const GENDER_MALE       = 0;
	const GENDER_FEMALE     = 1;
	const GENDER_OTHERS     = 2;

	const DEVICE_TYPE_IOS       = 0;
	const DEVICE_TYPE_ANDROID   = 1;
	const DEVICE_TYPE_WEB       = 2;

	/**
	 * Update the model in the database.
	 *
	 * @param  array $attributes
	 * @return bool|int
	 */
	public function update(array $attributes = [])
	{
		$this->setAttribute('birthday', Carbon::createFromFormat('d-m-Y', $this->getAttribute('birthday')));
		return parent::update($attributes);
	}
}
