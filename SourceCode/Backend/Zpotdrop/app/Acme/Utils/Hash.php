<?php

namespace App\Acme\Utils;

class Hash
{
    /***/
	protected static function createKey($length) {
        $key = '';
        $replace = array('/', '+', '=');
        while(strlen($key) < $length) {
            $key .= str_replace($replace, NULL, base64_encode(mcrypt_create_iv($length, MCRYPT_RAND)));
        }  
        return substr($key, 0, $length);
    }

	/**
	* Generate an ObjectId from a timestamp
	* @return string
	*/
	public static function hexId() {
		return substr(md5(microtime().uniqid() ), 0, 24);
	}
}