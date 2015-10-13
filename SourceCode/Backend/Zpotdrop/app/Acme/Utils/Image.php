<?php
namespace App\Acme\Utils;
class Image
{
	const PNG  = 'png';
	const GIF  = 'gif';
	const JPEG = 'jpeg';
	public static function img2base64( $file , $mime )
	{
		if( file_exists($file) && is_file($file) ) 
		{
			$imgData = base64_encode( static::readFile($file) );
			return 'data:'.$mime.';base64,'.$imgData;
		}
		return null;
	}
	public static function readFile( $filename ){
		if( function_exists('file_get_contents') )
		{
			return file_get_contents($filename);
		}
		else
		{
			$handle = fopen($filename, "r");
			$contents = fread($handle, filesize($filename));
			fclose($handle);
			return $contents;
		}
	}
	public static function base642img( $path , $string , $name = false)
	{
		if( empty($path) || empty($string) )
		{
			return false;
		}
		$data = preg_replace('#^data:image/\w+;base64,#i', '', $string);
		preg_match('/image\/(.*);/', $string, $match);
		if( isset($match[1]) )
		{
			$ext = $match[1];
		}
		if( empty($data) || ! isset($ext) )
		{
			return false;
		}
		$entry = base64_decode($data);
		$image = imagecreatefromstring($entry);
		if( ! $name )
		{
			$name = static::random();
		}
		$file = rtrim($name, '.'.$ext ).'.'. $ext;
		$directory = rtrim($path, DIRECTORY_SEPARATOR ).DIRECTORY_SEPARATOR. $file;
		$flag = false;
		switch ( $ext ) {

			case Image::PNG:
				if( imagepng($image, $directory) )
				{
					$flag = true;
				}
				break;
			case Image::JPEG:
				if( imagejpeg($image, $directory) )
				{
					$flag = true;
				}
				break;
			case Image::GIF:
				if( imagegif($image, $directory) )
				{
					$flag = true;
				}
				break;
				
			default:
				# code...
				break;
		}
		imagedestroy ( $image );
		if( $flag )
		{
			return $file;
		}
		return false;
	}
	public static function random()
	{
		return md5( microtime() );
	}
}