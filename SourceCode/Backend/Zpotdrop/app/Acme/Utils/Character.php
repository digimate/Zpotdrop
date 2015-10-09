<?php
namespace App\Acme\Utils;

class Character {
	
	/*
	* Replace accented UTF-8 characters by unaccented ASCII-7 equivalents
	* @param string $str: The UTF8 string to strip of special chars
	* @return string
	*/
	public static function UTF8Deaccent($str)
	{
		$str = html_entity_decode($str, ENT_NOQUOTES, 'UTF-8');
		
    	$trans = @file_get_contents(CONFIGURATION_DIR . '/utf-8.json');				
		$trans = (array)json_decode($trans);			
		return strtr($str, $trans);
	}

	/*
	* Wraps a string to a given number of characters
	* @param string $str: Text or string needle wordwrap
	* @param integer $maxLength: Max length of the string
	* @param string $suffix: Default ...
	* @param integer $option: Reference function self::stripTags
	* @return string
	*/
	public static function wordCut($str, $maxLength=255, $suffix='...',$option=0) {
		
		$str = html_entity_decode(self::stripTags($str,$option), ENT_NOQUOTES, 'UTF-8');	
		
		$str = rtrim($str, '.');
		
	    if (strlen($str) > $maxLength)
	    {			
			$wordWrap = wordwrap($str, ($maxLength-strlen($suffix)), '[cut]', 1);
			$wpExpode = explode('[cut]', $wordWrap);      
			$strCut = $wpExpode[0];      
			$result = rtrim($strCut, '.') . $suffix;
	    }
	    else
	    {
		   $result = $str;
	    }	  
		return $result;
	}
	
	public static function stripTags($str,$option=0) {	
		$str = str_replace('\\','', $str);
		return $str;		
	}
	
	public static function ipAddr() {
		if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
			$ip = $_SERVER['HTTP_CLIENT_IP'];
		} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
			$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
		} else {
			$ip = $_SERVER['REMOTE_ADDR'];
		}
		return $ip;
	}
	/**
	* Convert base64 to private rule
	* @param string $str
	* @return string
	*/
	public static function base64Encrypt($str) {
	
		if(!isset($str) || empty($str)) return '';
		$str = base64_encode(self::stripTags($str));		
		$oddChar = '';
		$evenChar = '';
		$len = strlen($str);		
		for($i=0;$i<$len;$i++) {
			if($i%2 == 0)
				$evenChar .= substr($str,$i,1);
			else
				$oddChar .= substr($str,$i,1);
		}		
		return strrev($evenChar) . '-' . strrev($oddChar);
	}
	/**
	* Convert base64 <private rule> to basic
	* @param string $str
	* @return string
	*/
	public static function base64Decrypt($str) {
		if(!isset($str) || empty($str)) return '';
		$arr = explode('-', $str);
		
		$oddChar = isset($arr[0]) ? strrev($arr[0]) : '';
		$evenChar = isset($arr[1]) ? strrev($arr[1]) : '';
		
		//return $oddChar .'-'. $evenChar;
		
		$lenOdd	= strlen($oddChar);
		$lenEven = strlen($evenChar);
		$len = $lenEven < $lenOdd ? $lenEven : $lenOdd;
		if($lenOdd == $lenEven) {
			$start = $oddChar;
			$end = $evenChar;
		} else {
			$start = $evenChar;
			$end = $oddChar;
		}
		$result = '';   
        for ($i = 0; $i < $len; $i++) {
			$result .= substr($start, $i, 1);
			$result .= substr($end, $i, 1);
        }		
        if ($len < $lenOdd) {
            $result .= substr($oddChar, -1, 1);
        } elseif ($len < $lenEven) {
            $result .= substr($evenChar, -1, 1);
        }
		$result = base64_decode($result);
        return $result;
	}
	
	public static function arr2Str($arr) {	
		$str = implode(',', $arr);
		return $str;
	}
}