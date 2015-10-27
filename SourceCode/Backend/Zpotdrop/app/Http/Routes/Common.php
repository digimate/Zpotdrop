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
/*
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
*/

Route::get('common/image/base64', ['as'=>'common.imagebase64', function(\Illuminate\Http\Request $request)
{
    $base64   = $request->get('base64', '');
    $width  = $request->get('width', \App\Acme\LZConstant::IMAGE_THUMB_WIDTH);
    $height = $request->get('height', \App\Acme\LZConstant::IMAGE_THUMB_HEIGHT);
    $type = $request->get('type', 'avatar');

    $imagePath = \App\Acme\Utils\Image\ResizeImage::base64($base64, $width, $height, $type);
    $img = Image::make(config('custom.upload_dir').'/'.$imagePath);
    return $img->response();
}]);

Route::get('terms-of-use', ['as' => 'terms_of_use', function(\Illuminate\Http\Request $request) {
    return view('common.terms-of-use');
}]);

Route::get('privacy-policy', ['as' => 'privacy_policy', function(\Illuminate\Http\Request $request) {
    return view('common.privacy-policy');
}]);
