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
use App\Acme\Transformers\FriendTransformer;
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
            return $this->lzResponse->badRequest(['user_id' => $userId, 'friend_id' => $friend_id]);
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
        $friendStatus = ($friend->is_private == User::PROFILE_PUBLIC) ? Friend::FRIEND_FOLLOW : Friend::FRIEND_REQUEST;
        $relation = Friend::create([
            'user_id' => $userId,
            'friend_id' => $friend_id,
            'is_friend' => $friendStatus
        ]);

        // dispatch event
        event(new UserFollowEvent($user, $friend, $friendStatus));

        return $this->lzResponse->success();
	}

    /**
     * @SWG\Post(
     *    path="/users/friends/{friend_id}/follow/accept",
     *   summary="Accept Follow request",
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
     *			description="ID of friend send request!",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Register successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function accept(Request $request, $friend_id)
    {
        if (empty($friend_id)) {
            return $this->lzResponse->badRequest(['friend_id' => trans('user.not_found.friend_id')]);
        }

        $userId = \Authorizer::getResourceOwnerId();

        if ($userId === $friend_id) {
            return $this->lzResponse->badRequest(['user_id' => $userId, 'friend_id' => $friend_id]);
        }
        $user = User::find($userId);
        $friend = User::where('id', $friend_id)->active()->first();
        if (!$friend) {
            return $this->lzResponse->badRequest(['friend_id' => trans('user.not_found.friend_id')]);
        }

        // update
        $relation = Friend::where('user_id', $friend_id)->where('friend_id', $userId)->where('is_friend', Friend::FRIEND_REQUEST)
               ->update(['is_friend' => Friend::FRIEND_FOLLOW]);
        if(!$relation) {
            return $this->lzResponse->error(LZResponse::HTTP_CONFLICT, trans('user.record_not_exists'));
        }
        // dispatch event
        event(new UserFollowEvent($friend, $user, Friend::FRIEND_FOLLOW));

        return $this->lzResponse->success();
    }


    /**
     * @SWG\get(
     *    path="/users/friends/{friend_id}/check",
     *   summary="Check Follow a friend",
     *   tags={"Users"},
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
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
    public function check(Request $request, $friend_id)
    {
        $userId = \Authorizer::getResourceOwnerId();

        if ($userId === $friend_id) {
            return $this->lzResponse->badRequest(['user_id' => $userId, 'friend_id' => $friend_id]);
        }


        // check exists action
        $relation = \Cache::remember("follow_{$userId}_{$friend_id}", config('custom.cache.long_time'), function() use($userId, $friend_id) {
            return Friend::where('user_id', $userId)
                ->where('friend_id', $friend_id)->first();
        });
        if(!$relation) {
            return $this->lzResponse->success(['status' => Friend::FRIEND_NO, 'text' => Friend::getFriendStatusText(Friend::FRIEND_NO)]);
        }
        return $this->lzResponse->success(['status' => $relation->is_friend, 'text' => Friend::getFriendStatusText($relation->is_friend)]);
    }


    /**
     * @SWG\get(
     *    path="/users/friends/followers",
     *   summary="Get followers",
     *   tags={"Users"},
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="page",
     *			description="Page index: 1,2,3,4",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="limit",
     *			description="Number of post want to get : min=1 ; max=500",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Register successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function followers(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $page = $request->get('page', 1);
        $limit = $request->get('limit');

        $followers = Friend::getFollowers($userId, $page, $limit);

        return $this->lzResponse->successTransformArrayModelsWithPagination($followers, new FriendTransformer());
    }


    /**
     * @SWG\get(
     *    path="/users/friends/followings",
     *   summary="Get followings",
     *   tags={"Users"},
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="page",
     *			description="Page index: 1,2,3,4",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="limit",
     *			description="Number of post want to get : min=1 ; max=500",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Register successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function followings(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $page = $request->get('page', 1);
        $limit = $request->get('limit');

        $followers = Friend::getFollowings($userId, $page, $limit);

        return $this->lzResponse->successTransformArrayModelsWithPagination($followers, new FriendTransformer());
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