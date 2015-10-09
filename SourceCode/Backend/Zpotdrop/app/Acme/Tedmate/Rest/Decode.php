<?php

/**
 * This is a class, that a response format
 * @author     Phung, Truong K <truongkimphung1982@gmail.com>
 * @copyright  Copyright (c) 2015
 */
namespace Tedmate\Rest;

class Decode {
	
	public static function fetch($json, &$error=null) {		
		$data = null;		
		try {
		
			$data = @json_decode($json);			
			
			if(is_object($data)) {
				
				$statusCode = isset($data->result->code) ? $data->result->code : 404;				
				
				if($statusCode == 200) {
					unset($data->result);
				} else {					
					$error = isset($data->result->errors) ? $data->result->errors : null;
					$data = null;
					if(isset($error->url)) unset($error->url);
					if(isset($error->method)) unset($error->method);
					if(isset($error->_format)) unset($error->_format);
				}
			} else {
				$data = null;
			}
		} catch(Exception $e) {			
			$data = null;
		}
		return $data;
	}
	
}
