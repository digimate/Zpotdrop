<?php

namespace App\Http\Requests;


class ZpotScanRequest extends Request
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
            'lat' => 'numeric|required_if:answer,1',
            'long' => 'numeric|required_if:answer,1',
            'distance' => 'integer'
        ];
    }
}
