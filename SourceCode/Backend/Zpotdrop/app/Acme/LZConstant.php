<?php
/*
|--------------------------------------------------------------------------
| Constant.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 11:44 AM
*/

namespace App\Acme;


class LZConstant
{
	/*Images*/
	const IMAGE_THUMB_WIDTH     = 120;
	const IMAGE_THUMB_HEIGHT    = 120;
	const IMAGE_COVER_WIDTH     = 640;
	const IMAGE_COVER_HEIGHT    = 340;

	const ACTIVE_YES        = 1;
	const ACTIVE_NO         = 0;
	const ACTIVE_MSG_ARR    = [
		Constant::ACTIVE_YES    => 'Yes',
		Constant::ACTIVE_NO     => 'No'
	];
}