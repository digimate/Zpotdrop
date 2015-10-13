<?php

namespace App\Http\Requests;

use App\Http\Requests\Request;

class UserUpdateRequest extends Request
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
	        'email'         => 'email|max:255|unique:users',
	        'password'      => 'min:6',
	        'avatar'        => 'mimes:jpeg,png,size:3072',
	        'first_name'    => 'required|max:255',
	        'last_name'     => 'required|max:255',
	        'phone_number'  => 'max:20|min:6',
	        'is_private'    => 'integer|in:0,1',
	        'is_enable_all_zpot'=> 'integer|in:0,1',
	        'lat'           => 'float',
	        'long'          => 'float',
	        'birthday'      => 'date|min:10|date_format:d-m-Y',
	        'gender'        => 'required|integer|in:0,1,2',
        ];
    }
}
