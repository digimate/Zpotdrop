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


use App\Acme\Images\LZImage;
use App\Acme\Models\User;
use App\Acme\Transformers\UserTransformer;
use App\Http\Requests\UserRequest;
use App\Http\Requests\UserUpdateRequest;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Auth;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="Users",
 *    description="show/edit/update/follow/unfollow/feeds",
 *    produces="['application/json']"
 * )
 */
class UserController extends ApiController
{
	/**
	 * @SWG\Api(
	 *    path="/users/profile/{id}/show",
	 *      @SWG\Operation(
	 *        method="POST",
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
		$user = User::find($id);
		if($user)
		{
			return $this->lzResponse->successTransformModel($user, new UserTransformer());
		}
		return $this->lzResponse->badRequest();
	}

	/**
	 * @SWG\Api(
	 *    path="/users/profile/edit",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Show detail profile for edit",
	 *		@SWG\ResponseMessage(code=200, message="Profile of current user"),
	 *    )
	 * )
	 */
	public function edit()
	{
		return $this->lzResponse->successTransformModel(\Auth::user(), new UserTransformer());
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
	public function update(UserUpdateRequest $request)
	{
		$user = new User();
		$user = $user->find(\Auth::id());
		$old_avatar = $user->avatar;
		$user->fill($request->all());

		/*Avatar come here*/
		if($request->hasFile('avatar') && $request->file('avatar')->isValid()){
			$user->avatar = LZImage::upload($request->file('avatar'), \Auth::id());
			/*delete old avatar*/
			LZImage::delete($old_avatar);
		}
		if($user->update()){
			return $this->lzResponse->success($user);
		}
		LZImage::delete($user->avatar);
		return $this->lzResponse->badRequest();
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