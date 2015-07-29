<?php
/*
|--------------------------------------------------------------------------
| ApiController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 11:46 AM
*/

namespace App\Http\Controllers\Api\v1;

use Illuminate\Routing\Controller as BaseController;
use App\Acme\Restful\LZResponse;

class ApiController extends BaseController
{
	/**
	 * @var LZResponse
	 */
	protected $lzResponse;
	/**
	 * ApiController constructor.
	 */
	public function __construct()
	{
		$this->lzResponse = new LZResponse();
	}
}