<?php
namespace App\Acme\Utils;

class Number {
	
	public static function formatPoint($number, $decimals = 0, $decPoint = ',', $thousandsSep = '.') {
		return number_format($number, $decimals, $decPoint, $thousandsSep);
	}
	
	public static function suffix($number){
		$k 	 = pow(10,3);
		$mil = pow(10,6);
		$bil = pow(10,9);
		
		if ($number >= $bil) {
			$number = round(($number / $bil),1);
			return str_replace('.0','',$number).'b';
		}
		elseif ($number >= $mil) {
			$number = round(($number / $mil),1);
			return str_replace('.0','',$number).'m';
		}
		elseif ($number >= $k) {
			$number = round(($number / $k),1);
			return str_replace('.0','',$number).'k';
		}
		else
			return (int)$number;
	}
}