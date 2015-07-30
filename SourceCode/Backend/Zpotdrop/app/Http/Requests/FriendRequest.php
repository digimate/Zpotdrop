<?php

namespace App\Http\Requests;


class FriendRequest extends Request
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'user_id'   => 'require|integer|exists:users,id',
	        'friend_id' => 'require|integer|exists:users,id',
	        'is_friend' => 'integer|in:0,1'
        ];
    }

	/**
	 * Determine if the request is the result of an AJAX call.
	 *
	 * @return bool
	 */
	public function ajax()
	{
		return parent::ajax(); // TODO: Change the autogenerated stub
	}
}
