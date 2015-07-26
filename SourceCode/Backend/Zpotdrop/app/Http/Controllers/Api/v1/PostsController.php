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

namespace app\Http\Controllers\Api\v1;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="Posts",
 *    description="show/edit/destroy/feed/like/comment",
 *    produces="['application/json']"
 * )
 */
class PostsController extends ApiController
{
	/**
	 * @SWG\Api(
	 *    path="/posts/{id}/show",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Get detail post",
	 *     @SWG\Parameter(
	 *			name="id",
	 *			description="ID of Post",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Detail of post"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function show($id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/posts/edit",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Show detail post",
	 *		@SWG\ResponseMessage(code=200, message="Post detail"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function edit()
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/posts/{id}/destroy",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Delete a post",
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function destroy($id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/posts/{id}/like",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Like a post",
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function like($id)
	{
	}

	/**
	 * @SWG\Api(
	 *    path="/posts/{id}/comment",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Comment a post",
	 *      @SWG\Parameter(
	 *			name="id",
	 *			description="ID of post!",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="integer"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="message",
	 *			description="Message",
	 *			paramType="query",
	 *      	required=true,
	 *      	allowMultiple=false,
	 *      	type="string"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function comment($id)
	{
	}
}