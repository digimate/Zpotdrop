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

class TableController extends ApiController
{
	/**
	 * @SWG\Get(
	 *    path="/tables/users",
     *   summary="Users table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function users()
	{
		return $this->lzResponse->success(User::first());
	}

	/**
	 * @SWG\Get(
	 *    path="/tables/friends",
     *   summary="Friend table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function friends()
	{
		return $this->lzResponse->success(Friend::with(['user', 'friend'])->first());
	}

	/**
	 * @SWG\Get(
	 *    path="/tables/posts",
     *   summary="Post table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function posts()
	{
		return $this->lzResponse->success(Post::with(['user', 'venue'])->first());
	}

	/**
	 * @SWG\Get(
	 *    path="/tables/likes",
     *   summary="Like table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function likes()
	{
		return $this->lzResponse->success(Like::with(['user', 'post'])->first());

	}

	/**
	 * @SWG\Get(
	 *    path="/tables/comments",
     *   summary="Comment table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function comments()
	{
		return $this->lzResponse->success(Like::with(['user', 'post'])->first());

	}

	/**
	 * @SWG\Get(
	 *    path="/tables/venues",
     *   summary="Venue table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function venues()
	{
		return $this->lzResponse->success(Venue::with(['user'])->first());
	}

	/**
	 * @SWG\Get(
	 *    path="/tables/notifications",
     *   summary="Notification table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function notifications()
	{
		return $this->lzResponse->success(Notification::with(['user', 'post', 'friend'])->first());
	}

	/**
	 * @SWG\Get(
	 *    path="/tables/request-zpots",
     *   summary="RequestZpot table",
     *   tags={"Tables"},
     * 	 @SWG\Response(response=200, description="")
	 * )
	 */
	public function requestzpots()
	{
		return $this->lzResponse->success(RequestZpot::with(['user', 'friend'])->first());
	}
}