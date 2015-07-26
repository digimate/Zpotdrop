<?php
/*
|--------------------------------------------------------------------------
| TablesController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 8:12 PM
*/

namespace App\Http\Controllers\Api\v1;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="Tables",
 *    description="users/friends",
 *    produces="['application/json']"
 * )
 */
class TablesController extends ApiController
{
	/**
	 * @SWG\Api(
	 *    path="/tables/users",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Users table",
	 *        type="Users",
	 *    )
	 * )
	 */
	public function users()
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/friends",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Friends table",
	 *        type="Friends",
	 *    )
	 * )
	 */
	public function friends()
	{
	}
}