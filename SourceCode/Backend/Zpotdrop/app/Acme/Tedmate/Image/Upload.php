<?php

/**
 * This is a class, that a upload image
 * @author     Phung, Truong K <truongkimphung1982@gmail.com>
 * @copyright  Copyright (c) 2015
 */
namespace Tedmate\Image;

use Tedmate\Utils\Character;

class Upload {

	const UPLOAD_OK = 0;//The file uploaded with success
	const UPLOAD_ERR_INI_SIZE = 1;
	const UPLOAD_ERR_FORM_SIZE = 2;
	const UPLOAD_ERR_PARTIAL = 3;
	const UPLOAD_ERR_NO_FILE = 4;	
	const UPLOAD_ERR_NO_TMP_DIR = 6;
	const UPLOAD_ERR_CANT_WRITE = 7;
	const UPLOAD_ERR_EXTENSION = 8;
	const UPLOAD_FILE_EMPTY = 9;

	public static function mkDirectory($target) {
		// from php.net/mkdir user contributed notes
		if (file_exists ( $target )) {
			if (! @ is_dir ( $target ))
				return false;
			else
				return true;
		}
		
		// Attempting to create the directory may clutter up our display.
		if (@ mkdir ( $target )) {
			$stat = @ stat ( dirname ( $target ) );
			$dir_perms = $stat ['mode'] & 0007777; // Get the permission bits.
			@ chmod ( $target, $dir_perms );
			return true;
		} else {
			if (is_dir ( dirname ( $target ) ))
				return false;
		}
		
		// If the above failed, attempt to create the parent node, then try again.
		if (self::mkDirectory ( dirname ( $target ) ))
			return mkDir ( $target );
		
		return false;
	}

	/**
	* Uploading file to folder specify
	* @param array $file: This uploaded file from PC
	* @param str $uploadDir
	* @param str $name
	* @return array 
	*/
	public static function process($file, $uploadDir = '', $name=null) {		
	
		if (!isset( $file ) || is_null($file['tmp_name']) || empty($file['name']))
			return ['error'=>self::UPLOAD_FILE_EMPTY];
		
		$error = isset($file['error']) ? $file['error'] : 0;
		if($error !== 0 ) {
			return ['error'=>$error];
		}
		
		$types = ['image/pjpeg', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'];
		if (!in_array($file['type'], $types)) {		
			return ['error'=>self::UPLOAD_ERR_EXTENSION];
		}
		if ($file['size'] <= 0 || $file['size'] > IMAGE_MAX_FILE_SIZE) {
			return ['error'=>self::UPLOAD_ERR_FORM_SIZE];
		}
		if(empty($uploadDir))
			$uploadDir = UPLOAD_DIR . '/'. date('Y/m/d');
			
		if( substr($uploadDir, -1, 1) != '/' ) $uploadDir .= '/';
		
		self::mkDirectory($uploadDir);
        $extension = strtolower(strrchr($file['name'], '.'));
		$altName = '';
		if (!is_null($name)) {
			$altName = $name;
			$name = md5($name);
		}	
		else
			$name = md5(rand(100, 999) . time());	
			
        $fileName = $name . $extension;
		$fullPath = $uploadDir . $fileName;
		
		move_uploaded_file($file['tmp_name'], $fullPath);		
		
		$sizes = @getimagesize($fullPath);
		$width = 0;
		$height	= 0;
		
		if(is_array($sizes) && count($sizes)) {
			$width 	=  $sizes[0];
			$height	=  $sizes[1];
		}	

		$path = str_replace(UPLOAD_DIR . '/', '', $uploadDir);
		$data = ['path'=>$path,'name'=>$name,'width'=>$width,'height'=>$height,'ext'=>$extension];
		$json = @json_encode($data);
		$base64 = Character::base64Encrypt($json);
		$data['alt_name'] = $altName;
		$data['base64'] = $base64;
		
		return [
			'error'=>self::UPLOAD_OK,
			'data'=>$data
		];
	}
	
	/**
	* Uploading image from url website
	* @param <inout>array $file: This uploaded file from PC
	* @param str $uploadDir
	* @param str $name
	* @return array 
	*/
	public static function processByUrl($url, $uploadDir = '', $name=null) {		
	
		if (empty($url) || @getimagesize($url) === false)
			return ['error'=>self::UPLOAD_FILE_EMPTY];
		
		if(empty($uploadDir))
			$uploadDir = UPLOAD_DIR . '/'. date('Y/m/d');
			
		if( substr($uploadDir, -1, 1) != '/' ) $uploadDir .= '/';
		
		self::mkDirectory($uploadDir);
        $extension = '.png';
		$altName = '';
		if (!is_null($name)) {
			$altName = $name;
			$name = md5($name);
		}	
		else
			$name = md5(rand(100, 999) . time());	
			
        $fileName = $name . $extension;
		$fullPath = $uploadDir . $fileName;
		
		$content = @file_get_contents($url); 		
		@file_put_contents($fullPath, $content);
		
		$sizes = @getimagesize($fullPath);
		$width = 0;
		$height	= 0;
		
		if(is_array($sizes) && count($sizes)) {
			$width 	=  $sizes[0];
			$height	=  $sizes[1];
		}	

		$path = str_replace(UPLOAD_DIR . '/', '', $uploadDir);
		$data = ['path'=>$path,'name'=>$name,'width'=>$width,'height'=>$height,'ext'=>$extension];
		$json = @json_encode($data);
		$base64 = Character::base64Encrypt($json);
		$data['alt_name'] = $altName;
		$data['base64'] = $base64;
		
		return [
			'error'=>self::UPLOAD_OK,
			'data'=>$data
		];
	}
}
