<?php
/*
|--------------------------------------------------------------------------
| UsersController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 1:45 PM
*/

namespace App\Http\Controllers\Api\v1;


use App\Models\User;
use Illuminate\Routing\Controller;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="Users",
 *    description="show/edit/update/follow/unfollow/feeds",
 *    produces="['application/json']"
 * )
 */
class UserController extends Controller
{
	/**
	 * @SWG\Api(
	 *    path="/users/profile/{id}/show",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Get detail profile of ID",
	 *     @SWG\Parameter(
	 *			name="id",
	 *			description="ID of user",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Profile of user"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function show($id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/users/profile/edit",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Show detail profile for edit",
	 *		@SWG\ResponseMessage(code=200, message="Profile of current user"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function edit()
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/users/profile/update",
	 *      @SWG\Operation(
	 *        method="PATCH",
	 *        summary="Update profile of current user",
	 *		@SWG\ResponseMessage(code=200, message="Update profile successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function update()
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/users/friends/{friend_id}/follow",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Follow a friend",
	 *      @SWG\Parameter(
	 *			name="friend_id",
	 *			description="ID of friend!",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Register successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function follow($friend_id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/users/friends/{friend_id}/un-follow",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="unFollow a friend",
	 *      @SWG\Parameter(
	 *			name="friend_id",
	 *			description="ID of friend!",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Register successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function unFollow($friend_id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/users/feeds",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Get feeds",
	 *      @SWG\Parameter(
	 *			name="page",
	 *			description="Page index",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="limit",
	 *			description="Maximum number of items want to get",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Feeds list"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function feeds($friend_id)
	{
	}
}