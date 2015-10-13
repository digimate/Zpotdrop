<?php
/*
|--------------------------------------------------------------------------
| LZImage.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/30/15 - 11:28 PM
*/

namespace App\Acme\Images;
use Image;
use App\Acme\LZConstant;

/**
 * Class LZImage
 * @package App\Acme\Images
 */
class LZImage
{
	/**
	 * @param $file
	 * @param string $id
	 * @param string $path
	 * @param int $width
	 * @param int $height
	 * @return string
	 */
	public static function upload($file,
	                              $id       = '',
	                              $path     = 'avatar',
	                              $width    = LZConstant::IMAGE_THUMB_WIDTH,
	                              $height   = LZConstant::IMAGE_THUMB_HEIGHT)
	{
		$full_path = 'uploads' . DIRECTORY_SEPARATOR . $path;
		if(!\File::exists(public_path('ddasd'))){
			\File::makeDirectory(public_path($full_path), 755, true, true);
		}

		if($file){
			$name = $full_path . DIRECTORY_SEPARATOR . md5(microtime(). $id) . '.jpg';
			$img = Image::make($file);
			$img->fit($width, $height);
			$img->save($name);
			return $name;
		}
		return 'no-image.jpg';
	}

	/**
	 * @param $file_path
	 * @return bool
	 */
	public static function delete($image_json){
//
//		if(\File::isFile($file_path) && \File::exists($file_path)){
//			\File::delete($file_path);
//		}
//		return false;
	}
}