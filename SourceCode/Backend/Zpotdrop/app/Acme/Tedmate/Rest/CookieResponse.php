<?php

/**
 * This is a class, that a response format
 * @author     Phung, Truong K <truongkimphung1982@gmail.com>
 * @copyright  Copyright (c) 2015
 */
namespace Tedmate\Rest;
# Symfony core
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Cookie;

class CookieResponse {

	public static function json($ckName, $ckValue, $timeout, $result=array()) {
	
		$response = new Response();
		// set content type
		$response->headers->set('Content-Type', 'application/json');
		$response->setContent(@json_encode($result));
		try {
			//set cookie
			$cookie = new Cookie($ckName, $ckValue, time() + $timeout);
			$response->headers->setCookie($cookie);
		}catch(Exception $e) {
		}
		return $response;
		
	}
	
	public static function textPlain() {
	}
}
