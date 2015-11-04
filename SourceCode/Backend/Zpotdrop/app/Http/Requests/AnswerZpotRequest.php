<?php

namespace App\Http\Requests;


class AnswerZpotRequest extends Request
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
            'notification_id' => 'required|numeric|min:0',
            'answer' => 'required|integer|in:0,1',
            'lat' => 'numeric|required_if:answer,1',
            'long' => 'numeric|required_if:answer,1',
        ];
    }
}
