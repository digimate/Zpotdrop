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

class UserController extends ApiController
{
	/**
	 * @SWG\POST(
	 *    path="/users/profile/{id}/show",
     *   summary="Get detail profile of ID",
     *   tags={"Users"},
	 *     @SWG\Parameter(
	 *			name="id",
	 *			description="ID of user",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Profile of user"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *    
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
	 * @SWG\POST(
	 *    path="/users/profile/edit",
     *   summary="Show detail profile for edit",
     *   tags={"Users"},
	 *		@SWG\Response(response=200, description="Profile of current user"),
	 *
	 * )
	 */
	public function edit()
	{
		return $this->lzResponse->successTransformModel(\Auth::user(), new UserTransformer());
	}

	/**
	 * @SWG\PATCH(
	 *    path="/users/profile/update",
     *   summary="Update profile of current user",
     *   tags={"Users"},
	 *		@SWG\Response(response=200, description="Update profile successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
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
	 * @SWG\POST(
	 *    path="/users/friends/{friend_id}/follow",
     *   summary="Follow a friend",
     *   tags={"Users"},
	 *      @SWG\Parameter(
	 *			name="friend_id",
	 *			description="ID of friend!",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Register successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function follow($friend_id)
	{
	}

	/**
	 * @SWG\POST(
	 *    path="/users/friends/{friend_id}/un-follow",
     *   summary="unFollow a friend",
     *   tags={"Users"},
	 *      @SWG\Parameter(
	 *			name="friend_id",
	 *			description="ID of friend!",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Register successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function unFollow($friend_id)
	{
	}

	/**
	 * @SWG\GET(
	 *    path="/users/feeds",
     *   summary="Get feeds",
     *   tags={"Users"},
	 *      @SWG\Parameter(
	 *			name="page",
	 *			description="Page index",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="limit",
	 *			description="Maximum number of items want to get",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Feeds list"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function feeds($friend_id)
	{
	}
}