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
use App\Acme\Models\Friend;
use App\Acme\Models\Like;
use App\Acme\Models\Notification;
use App\Acme\Models\Post;
use App\Acme\Models\RequestZpot;
use App\Acme\Models\User;
use App\Acme\Models\Venue;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="Tables",
 *    description="Detail fields of each table",
 *    produces="['application/json']"
 * )
 */
class TableController extends ApiController
{
	/**
	 * @SWG\Api(
	 *    path="/tables/users",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Users table",
	 *        type="User",
	 *    )
	 * )
	 */
	public function users()
	{
		return $this->lzResponse->success(User::first());
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/friends",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Friends table",
	 *        type="Friend",
	 *    )
	 * )
	 */
	public function friends()
	{
		return $this->lzResponse->success(Friend::with(['user', 'friend'])->first());
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/posts",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Posts table",
	 *        type="Post",
	 *    )
	 * )
	 */
	public function posts()
	{
		return $this->lzResponse->success(Post::with(['user', 'venue'])->first());
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/likes",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Likes table",
	 *        type="Like",
	 *    )
	 * )
	 */
	public function likes()
	{
		return $this->lzResponse->success(Like::with(['user', 'post'])->first());

	}

	/**
	 * @SWG\Api(
	 *    path="/tables/comments",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Comments table",
	 *        type="Comment",
	 *    )
	 * )
	 */
	public function comments()
	{
		return $this->lzResponse->success(Like::with(['user', 'post'])->first());

	}

	/**
	 * @SWG\Api(
	 *    path="/tables/venues",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Venues table",
	 *        type="Venue",
	 *    )
	 * )
	 */
	public function venues()
	{
		return $this->lzResponse->success(Venue::with(['user'])->first());
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/notifications",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Notifications table",
	 *        type="Notification",
	 *    )
	 * )
	 */
	public function notifications()
	{
		return $this->lzResponse->success(Notification::with(['user', 'post', 'friend'])->first());
	}

	/**
	 * @SWG\Api(
	 *    path="/tables/request-zpots",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="RequestZpot table",
	 *        type="RequestZpot",
	 *    )
	 * )
	 */
	public function requestzpots()
	{
		return $this->lzResponse->success(RequestZpot::with(['user', 'friend'])->first());
	}
}