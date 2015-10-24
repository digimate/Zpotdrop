<?php

namespace App\Http\Requests;

use App\Acme\Models\Location;
use App\Acme\Models\User;
use Illuminate\Contracts\Validation\Validator;

class LocationSearchRequest extends Request
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;//no need authenticate to use this one
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'lat'           => 'required|numeric',
            'long'          => 'required|numeric',
            'keyword'       => 'required|max:255',
        ];
    }

	/**
	 * Set custom attributes for validator errors.
	 *
	 * @return array
	 */
	public function attributes()
	{
		return parent::attributes(); // TODO: Change the autogenerated stub
	}
}
