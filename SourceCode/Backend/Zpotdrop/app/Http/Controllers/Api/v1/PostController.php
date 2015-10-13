<?php
/*
|--------------------------------------------------------------------------
| PostsController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 6:27 PM
*/

namespace App\Http\Controllers\Api\v1;
use App\Acme\Models\Like;
use App\Acme\Models\Post;
use App\Acme\Transformers\PostTransformer;

class PostController extends ApiController
{
	/**
	 * @SWG\Get(
	 *    path="/posts/list",
     *   summary="Get posts",
     *   tags={"Posts"},
	 *      @SWG\Parameter(
	 *			name="page",
	 *			description="Page index: 1,2,3,4",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="limit",
	 *			description="Number of post want to get",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Detail of post"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function index()
	{
//		$post = Post::with(['comments', 'likes', 'user', 'comments.user', 'likes.user'])->paginate(\Input::get
//		('limit', 15))->items();
		$posts = Post::with(['user'])->get()->all();

		return $this->lzResponse->successTransformArrayModels($posts, new PostTransformer());
	}

	/**
	 * @SWG\Get(
	 *    path="/posts/{id}/show",
     *   summary="Get detail post",
     *   tags={"Posts"},
	 *     @SWG\Parameter(
	 *			name="id",
	 *			description="ID of Post",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Detail of post"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function show($id)
	{

	}

	/**
	 * @SWG\Get(
	 *    path="/posts/edit",
     *   summary="Show detail post",
     *   tags={"Posts"},
	 *		@SWG\Response(response=200, description="Post detail"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function edit()
	{
	}

	/**
	 * @SWG\Delete(
	 *    path="/posts/{id}/destroy",
     *   summary="Delete a post",
     *   tags={"Posts"},
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function destroy($id)
	{
	}

	/**
	 * @SWG\Post(
	 *    path="/posts/{id}/like",
     *   summary="Like a post",
     *   tags={"Posts"},
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *		@SWG\Response(response=200, description="Successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function like($id)
	{
		$like = new Like();
		$like->user_id = 1;
		$like->post_id = $id;
		echo $like->save();
	}

	/**
	 * @SWG\Post(
	 *    path="/posts/{id}/comment",
     *   summary="Comment a post",
     *   tags={"Posts"},
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="message",
	 *			description="Message",
	 *			in="query",
	 *      	required=true,
	 *      	type="string"
	 *      	),
	 *		@SWG\Response(response=200, description="Successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *
	 * )
	 */
	public function comment($id)
	{
	}
}