<?php

namespace App\Acme\Models;

use Carbon\Carbon;
use Fadion\Bouncy\BouncyTrait;
use Illuminate\Auth\Authenticatable;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;
use Hashids;
use Vinkla\Hashids\HashidsServiceProvider;

/**
 * App\Models\User
 *
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
 * @property string $birthday
 * @property boolean $gender
 */
class User extends BaseModel implements AuthenticatableContract, CanResetPasswordContract
{
	use BouncyTrait, Authenticatable, CanResetPassword;

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
        'status',
		'is_private',
		'is_enable_all_zpot',
		'lat',
		'long',
		'device_id',
		'device_name',
		'device_type',
        'hash'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['password', 'remember_token'];

    /**
     * elastic-search mapping
     * @var array
     */
    protected $mappingProperties = array(
        'id' => [
            'type' => 'long',
            'analyzer' => 'standard'
        ],
        'email' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'avatar' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'hash' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'birthday' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'gender' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'phone_number' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'home_town' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'is_private' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'is_enable_all_zpot' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'lat' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'long' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        "geo_point" => [
            "type" => "geo_point",
            "analyzer" => "stop",
            "stopwords" => [","]
        ],
        'first_name' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'last_name' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'username' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'follower_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'following_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'drop_count' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'status' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'device_id' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'device_type' => [
            'type' => 'integer',
            'analyzer' => 'standard'
        ],
        'created_at' => [
            'type' => 'string'
        ]
    );

    /**
     * elastic document data
     * @return array
     */
    public function documentFields()
    {
        return [
            'id' => $this->id,
            'email' => $this->email,
            'geo_point' => $this->lat . ", " . $this->long,
            'username' => $this->first_name . ' ' . $this->last_name,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'avatar' => $this->avatar,
            'hash' => $this->hash,
            'birthday' => $this->birthday,
            'gender' => $this->gender,
            'phone_number' => $this->phone_number,
            'home_town' => $this->home_town,
            'is_private' => $this->is_private,
            'follower_count' => $this->follower_count,
            'following_count' => $this->following_count,
            'drop_count' => $this->drop_count,
            'status' => $this->status,
            'device_id' => $this->device_id,
            'device_type' => $this->device_type,
            'created_at' => $this->created_at
        ];
    }

    public static $rule = [
        'email'         => 'required|email|max:255|unique:users',
        'password'      => 'required|min:6',
        'avatar'        => 'mimes:jpeg,png',
        'first_name'    => 'required|max:255',
        'last_name'     => 'required|max:255',
        'phone_number'  => 'max:20|min:6|unique:users',
        'is_private'    => 'integer|in:0,1',
        'is_enable_all_zpot'=> 'integer|in:0,1',
        'lat'           => 'required|numeric',
        'long'          => 'required|numeric',
        'birthday'      => 'date|date_format:d-m-Y',
        'gender'        => 'required|integer|in:0,1,2',
        'device_type'   => 'required|integer|in:0,1',
        'device_id'     => 'required'
    ];

    public static $socialRules = [
        'username'      => 'required|email|max:255',
        'email'      => 'required|email|max:255',
        'password'      => 'min:6',
        'avatar'        => 'mimes:jpeg,png',
        'first_name'    => 'required|max:255',
        'last_name'     => 'required|max:255',
        'phone_number'  => 'max:20|min:6|unique:users',
        'is_private'    => 'integer|in:0,1',
        'is_enable_all_zpot'=> 'integer|in:0,1',
        'lat'           => 'required|numeric',
        'long'          => 'required|numeric',
        'birthday'      => 'date|date_format:d-m-Y',
        'gender'        => 'required|integer|in:0,1,2',
        'device_type'   => 'required|integer|in:0,1',
        'device_id'     => 'required',
        'uid'           => 'required',
        'provider'      => 'required|in:facebook',
        'access_token' => 'required'
    ];

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

    // theo db, is_private=1
    const PROFILE_PRIVATE = 1;
    const PROFILE_PUBLIC = 0;

    const ZPOT_ALL_ENABLE = 1;
    const ZPOT_ALL_DISABLE = 0;

    /**
     * Scope a query to only include active users.
     *
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->where('status', self::STATUS_ACTIVE);
    }

    public function username() {
        return $this->first_name . ' ' . $this->last_name;
    }
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
