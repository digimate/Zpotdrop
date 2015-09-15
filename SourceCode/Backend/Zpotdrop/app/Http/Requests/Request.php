<?php

namespace App\Http\Requests;

use App\Acme\Restful\LZResponse;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exception\HttpResponseException;

abstract class Request extends FormRequest
{
	protected $lzResponse;

	public function __construct()
	{
		$this->lzResponse = new LZResponse();
	}

	/**
	 * Handle a failed validation attempt.
	 *
	 * @param  \Illuminate\Contracts\Validation\Validator $validator
	 * @return mixed
	 */
	protected function failedValidation(Validator $validator)
	{
		if(self::ajax()){
			throw new HttpResponseException($this->lzResponse->badRequest($validator->errors()->all()));
		}
		parent::failedValidation($validator);
	}

	/**
	 * Determine if the request is the result of an AJAX call.
	 *
	 * @return bool
	 */
	public function ajax()
	{
		return true;
	}


}
