<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;

/**
 * App\User
 *
 * @property integer $id
 * @property string $email
 * @property string $password
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
 * @property string $remember_token
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @method static \Illuminate\Database\Query\Builder|\App\User whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereEmail($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User wherePassword($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereFirstName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereLastName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User wherePhoneNumber($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereHomeTown($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereAge($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereIsPrivate($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereIsEnableAllZpot($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereLat($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereLong($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereStatus($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereRememberToken($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\User whereUpdatedAt($value)
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
		'first_name',
		'last_name',
		'phone_number',
		'home_town',
		'age',
		'is_private',
		'is_enable_all_zpot',
		'lat',
		'long',
		'status'
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
	const STATUS_ACTIVE     = true;
	const STATUS_INACTIVE   = false;

	/*
	 * Repository
	 */
}
