<?php
/*
|--------------------------------------------------------------------------
| NotificationController.php
|--------------------------------------------------------------------------
| @Author     : Nhieu Nguyen
| @Email      : nhieunguyenkhtn@gmail.com
| @Copyright  : © 2015 ZpotDrop.
| @Date       :
*/

namespace App\Http\Controllers\Api\v1;


use App\Acme\Images\LZImage;
use App\Acme\Models\Friend;
use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Acme\Restful\LZResponse;
use App\Acme\Transformers\FriendTransformer;
use App\Acme\Transformers\NotificationTransformer;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Image\Upload;
use App\Events\UserFollowEvent;
use App\Http\Requests\UserUpdateRequest;
use Illuminate\Http\Request;

class NotificationController extends ApiController
{
    /**
     * @SWG\Get(
     *    path="/notifications/list",
     *   summary="Get followers",
     *   tags={"Notifications"},
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
     *		@SWG\Response(response=200, description="successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function getNotifications(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $page = $request->get('page', 1);
        $limit = $request->get('limit');

        $notifications = Notification::getNotifications($userId, $page, $limit);

        return $this->lzResponse->successTransformArrayModelsWithPagination($notifications, new NotificationTransformer());
    }

    /**
     * @SWG\Post(
     *    path="/notifications/{id}/read",
     *   summary="Mark read the notification",
     *   tags={"Notifications"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="id",
     *			description="Notification's ID",
     *			in="formData",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function markRead(Request $request, $id)
    {
        $userId = \Authorizer::getResourceOwnerId();

        if (!Notification::where('id', $id)->where('friend_id', $userId)->update(['is_read' => Notification::IS_READ])) {
            return $this->lzResponse->badRequest(['notification_id' => trans('notification.notification_not_found')]);
        }
        return $this->lzResponse->success();
    }
}