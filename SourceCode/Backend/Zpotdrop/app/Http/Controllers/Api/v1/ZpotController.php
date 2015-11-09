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
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Time;
use App\Events\PostComingEvent;
use App\Events\PostCommentEvent;
use App\Events\PostLikeEvent;
use App\Http\Requests\AnswerZpotRequest;
use App\Http\Requests\CommentRequest;
use App\Http\Requests\PostRequest;
use App\Http\Requests\ZpotScanRequest;
use App\Jobs\IndexPostCreate;
use App\Jobs\LogUserAction;
use App\Jobs\ScanNotify;
use App\Jobs\UpdateUserDropWhenCreatePost;
use App\Jobs\ZpotAcceptRequestNotify;
use App\Jobs\ZpotRequestNotify;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

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
        $this->dispatch(new LogUserAction($userId, Notification::ACTION_TYPE_ZPOT_REQUEST));
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


    /**
     * @SWG\Post(
     *    path="/zpot/scan",
     *   summary="Zpot scan",
     *   tags={"Zpot"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="lat",
     *			description="Latitude",
     *			in="formData",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="long",
     *			description="Longitude",
     *			in="formData",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="distance",
     *			description="Radius to scan (km)",
     *			in="formData",
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function scan(ZpotScanRequest $request)
    {
        $lat = $request->input('lat');
        $long = $request->input('long');
        $distance = $request->get('distance');
        $userId = \Authorizer::getResourceOwnerId();

        $results = Friend::scan($userId, $lat, $long, $distance);

        if ($results->total() > 0) {
            //var_dump($results->toArray());die;
            $this->dispatch(new ScanNotify($userId, $results->toArray()));
        }
        $this->dispatch(new LogUserAction($userId, Notification::ACTION_TYPE_ZPOT_REQUEST));
        return $this->lzResponse->success(['total' => $results->total()]);
    }


    /**
     * @SWG\Post(
     *    path="/zpot/zpotall",
     *   summary="Zpot all",
     *   tags={"Zpot"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *		@SWG\Response(response=200, description="Successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function zpotAll(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $user = User::where('id', $userId)->select('id', 'first_name', 'last_name', 'zpot_all_time')->first();
        if ($user->zpot_all_time != null && strtotime($user->zpot_all_time) >= Time::getStartDay()->getTimestamp()) {
            return $this->lzResponse->badRequest([trans('user.already_zpot_all')]);
        }

        $this->dispatch(new LogUserAction($userId, Notification::ACTION_TYPE_ZPOT_ALL));
        return $this->lzResponse->success([]);
    }

    /**
     * @SWG\Get(
     *    path="/zpot/zpotall/check",
     *   summary="Check Zpot all on day",
     *   tags={"Zpot"},
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="status=1:zpoted; status=0:not zpot yet"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function zpotAllCheck(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $user = User::where('id', $userId)->select('id', 'first_name', 'last_name', 'zpot_all_time')->first();
        if ($user->zpot_all_time != null && strtotime($user->zpot_all_time) >= Time::getStartDay()->getTimestamp()) {
            return $this->lzResponse->success([
                'status' => 1,
                'zpot_all_time' => $user->zpot_all_time
            ]);
        }

        return $this->lzResponse->success([
            'status' => 0,
            'zpot_all_time' => $user->zpot_all_time
        ]);
    }
}