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
use App\Acme\Models\Friend;
use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Acme\Restful\LZResponse;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Image\Upload;
use App\Events\UserFollowEvent;
use App\Http\Requests\UserUpdateRequest;
use Illuminate\Http\Request;

class FollowController extends ApiController
{
	/**
	 * @SWG\Post(
	 *    path="/users/friends/{friend_id}/follow",
     *   summary="Follow a friend",
     *   tags={"Users"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
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
	public function follow(Request $request, $friend_id)
	{
        $userId = \Authorizer::getResourceOwnerId();

        if ($userId === $friend_id) {
            return $this->lzResponse->badRequest();
        }
        $user = User::find($userId);
        $friend = User::where('id', $friend_id)->active()->first();
        if (!$friend) {
            return $this->lzResponse->badRequest(['friend_id' => trans('user.not_found.friend_id')]);
        }

        // check exists action
        $relation = Friend::where('user_id', $userId)
                            ->where('friend_id', $friend_id)->first();
        if($relation) {
            return $this->lzResponse->error(LZResponse::HTTP_CONFLICT, trans('user.action_exists'));
        }

        // insert
        $relation = Friend::create([
            'user_id' => $userId,
            'friend_id' => $friend_id,
            'is_friend' => ($friend->is_private == User::PROFILE_PUBLIC) ? Friend::FRIEND_FOLLOW : Friend::FRIEND_REQUEST
        ]);

        // dispatch event
        event(new UserFollowEvent($user, $friend));

        return $this->lzResponse->success();
	}

	/**
	 * @SWG\Post(
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
	 * @SWG\Get(
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