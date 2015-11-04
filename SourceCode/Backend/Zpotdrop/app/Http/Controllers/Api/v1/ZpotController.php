<?php
/*
|--------------------------------------------------------------------------
| ZpotController.php
|--------------------------------------------------------------------------
| @Author     : Nhieu Nguyen
| @Email      : nhieunguyenkhtn@gmail.com
| @Copyright  : © 2015 ZpotDrop.
| @Date       :
*/

namespace App\Http\Controllers\Api\v1;
use App\Acme\Models\Comment;
use App\Acme\Models\Friend;
use App\Acme\Models\Like;
use App\Acme\Models\Notification;
use App\Acme\Models\Post;
use App\Acme\Models\PostComing;
use App\Acme\Models\User;
use App\Acme\Transformers\CommentTransformer;
use App\Acme\Transformers\LikeTransformer;
use App\Acme\Transformers\PostComingTransformer;
use App\Acme\Transformers\PostTransformer;
use App\Events\PostComingEvent;
use App\Events\PostCommentEvent;
use App\Events\PostLikeEvent;
use App\Http\Requests\AnswerZpotRequest;
use App\Http\Requests\CommentRequest;
use App\Http\Requests\PostRequest;
use App\Jobs\IndexPostCreate;
use App\Jobs\UpdateUserDropWhenCreatePost;
use App\Jobs\ZpotAcceptRequestNotify;
use App\Jobs\ZpotRequestNotify;
use Illuminate\Http\Request;

class ZpotController extends ApiController
{
    /**
     * @SWG\Post(
     *    path="/zpot/users/{id}/request",
     *   summary="Zpot request",
     *   tags={"Zpot"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="id",
     *			description="Friend's id",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Request zpot successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function request(Request $request, $id)
    {
        if (empty($id)) {
            return $this->lzResponse->badRequest(['id' => trans('user.not_found.friend_id')]);
        }

        $userId = \Authorizer::getResourceOwnerId();
        $user = User::find($userId);
        // check friend
        $relation = Friend::where('user_id', $userId)->where('friend_id', $id)->where('is_friend', Friend::FRIEND_YES)->first();
        if (!$relation) {
            return $this->lzResponse->badRequest(['id' => trans('user.not_found.friend_id')]);
        }

        // create notification
        $message = trans('notification.zpot');
        $params = [
            '{username}' => $user->username()
        ];
        $message = str_replace(['{username}'], [$user->username()], $message);
        $params = json_encode($params);
        $notification = Notification::create([
            'user_id' => $userId,
            'friend_id' => $id,
            'message' => $message,
            'params' => $params,
            'action_type' => Notification::ACTION_TYPE_ZPOT_REQUEST,
            'is_read' => Notification::IS_UNREAD
        ]);
        $this->dispatch(new ZpotRequestNotify($notification));
        return $this->lzResponse->success();
    }

	/**
	 * @SWG\Post(
	 *    path="/zpot/users/answer",
     *   summary="Answer zpot request",
     *   tags={"Zpot"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
	 *      @SWG\Parameter(
	 *			name="notification_id",
	 *			description="Notification's ID",
	 *			in="formData",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="answer",
	 *			description="Answer : 1=yes; 0=no",
	 *			in="formData",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
     *      @SWG\Parameter(
     *			name="lat",
     *			description="Latitude",
     *			in="formData",
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="long",
     *			description="Longitude",
     *			in="formData",
     *      	type="string"
     *      	),
	 *		@SWG\Response(response=200, description="Successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function answer(AnswerZpotRequest $request)
	{
        $notificationId = $request->input('notification_id');
        $answer = $request->input('answer');
        $notification = Notification::find($notificationId);
        if (!$notification) {
            return $this->lzResponse->badRequest();
        }
        /*$notification->is_read = Notification::IS_READ;
        $notification->save();*/

        if ($answer == 1) {
            User::where('id', \Authorizer::getResourceOwnerId())->update([
                'lat' => $request->input('lat'),
                'long' => $request->input('long')
            ]);
            $this->dispatch(new ZpotAcceptRequestNotify($notification));
        } else {
            $notification->is_read = Notification::IS_READ;
            $notification->save();
        }

		return $this->lzResponse->success();
	}
}