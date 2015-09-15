<?php
/*
|--------------------------------------------------------------------------
| Common.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/30/15 - 11:31 PM
*/

/*Image processing*/
Route::get('common/image', ['as'=>'common.imagefit', function(\Illuminate\Http\Request $request)
{
	$path   = $request->get('path', '');
	$width  = $request->get('width', \App\Acme\LZConstant::IMAGE_THUMB_WIDTH);
	$height = $request->get('height', \App\Acme\LZConstant::IMAGE_THUMB_HEIGHT);
	if(!File::exists($path)){
		$img = Image::canvas($width, $height, '#cccccc');
		$img->fit($width, $height);
		return $img->response('jpg');
	}
	$img = Image::make($path);
	$img->fit($width, $height);
	return $img->response('jpg');
}]);