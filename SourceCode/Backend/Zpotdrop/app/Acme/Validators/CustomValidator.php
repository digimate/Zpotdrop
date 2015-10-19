<?php
/**
 * Created by PhpStorm.
 * User: Nhieu Nguyen
 * Date: 10/19/2015
 * Time: 15:22
 */

namespace App\Acme\Validators;


class CustomValidator
{
    public function validateOldPassword($attribute, $value, $parameters) {
        return \Hash::check($value, \Auth::user()->password);
    }
}