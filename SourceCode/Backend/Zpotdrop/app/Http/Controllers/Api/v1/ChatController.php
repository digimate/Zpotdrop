<?php
/*
|--------------------------------------------------------------------------
| ChatController.php
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
use App\Acme\Models\Room;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Acme\Restful\LZResponse;
use App\Acme\Transformers\FriendTransformer;
use App\Acme\Transformers\NotificationTransformer;
use App\Acme\Transformers\RoomTransformer;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Hash;
use App\Acme\Utils\Image\Upload;
use App\Events\UserFollowEvent;
use App\Http\Requests\RoomRequest;
use App\Http\Requests\UserUpdateRequest;
use Illuminate\Http\Request;

class ChatController extends ApiController
{
    /**
     * @SWG\Get(
     *    path="/chat/rooms",
     *   summary="Get rooms",
     *   tags={"Chat"},
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
    public function getRooms(Request $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $page = $request->get('page', 1);
        $limit = $request->get('limit');

        $rooms = Room::getRooms($userId, $page, $limit);

        return $this->lzResponse->successTransformArrayModelsWithPagination($rooms, new RoomTransformer());
    }

    /**
     * @SWG\Post(
     *    path="/chat/room/create",
     *   summary="Create room's id if not exists",
     *   tags={"Chat"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="name",
     *			description="Room's name ",
     *			in="formData",
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="member_ids",
     *			description="Members id [format: userId1,userId2,...,userIdn ] ",
     *			in="formData",
     *          required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="room_type",
     *			description="Default is 1 (chat 1:1), 2 (chat group)",
     *			in="formData",
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function createRoom(RoomRequest $request)
    {
        $userId = \Authorizer::getResourceOwnerId();
        $roomType = $request->input('room_type', 1);
        $memberIds = $request->input('member_ids');
        $memberIds = array_unique(explode(',', $memberIds));
        if (($roomType == 1 && count($memberIds) != 2) || count($memberIds) == 0) {
            return $this->lzResponse->badRequest(['member_ids' => trans('user.member_ids_require_user')]);
        }
        $members = User::whereIn('id', $memberIds)->active()->select(['id'])->get();
        if (count($memberIds) != count($members)) {
            return $this->lzResponse->badRequest(['member_ids' => trans('user.member_ids_not_exists')]);
        }

        // chat 1:1
        if ($roomType == 1) {
            $roomId = $this->createRoomOneOne($memberIds[0], $memberIds[1]);

            // if room exist, then return
            $room = Room::findRoomById($roomId);
            if ($room) {
                return $this->lzResponse->successTransformModel($room, new RoomTransformer());
            }
        } else {
            $roomId = Hash::hexId();
        }
        $room = Room::create([
            'room_id' => $roomId,
            'user_id' => $userId,
            'name' => $request->input('name'),
            'member_ids' => $members
        ]);
        return $this->lzResponse->successTransformModel($room, new RoomTransformer());
    }

    private function createRoomOneOne($userId1, $userId2) {
        if ($userId1 > $userId2) {
            return md5($userId1.'_'.$userId2);
        }
        return md5($userId2.'_'.$userId1);
    }
}