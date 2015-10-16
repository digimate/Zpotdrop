<?php

namespace App\Acme\Models;

use Illuminate\Database\Eloquent\Model;

class UserSocial extends Model
{
    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'user_social';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'uid',
        'provider',
        'email',
        'username',
        'first_name',
        'last_name',
        'gender',
        'access_token'
    ];
}
