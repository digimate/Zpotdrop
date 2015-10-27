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
use App\Acme\Models\Friend;
use App\Acme\Models\Like;
use App\Acme\Models\Post;
use App\Acme\Models\User;
use App\Acme\Transformers\PostTransformer;
use App\Http\Requests\PostRequest;
use App\Jobs\IndexPostCreate;
use App\Jobs\UpdateUserDropWhenCreatePost;
use Illuminate\Http\Request;

class PostController extends ApiController
{
    /**
     * @SWG\Post(
     *    path="/posts/create",
     *   summary="Add new post",
     *   tags={"Posts"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="content",
     *			description="Post's content",
     *			in="formData",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="user_tags",
     *			description="With users format user_id1,user_id2,...",
     *			in="formData",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="location_id",
     *			description="Location",
     *			in="formData",
     *      	type="string"
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
     *		@SWG\Response(response=200, description="Register successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function add(PostRequest $request)
    {
        $userTags = $request->input('user_tags');
        if ($userTags) {
            $userTags = explode(",", $userTags);
            if (is_array($userTags) && count($userTags) > 0) {
                $users = User::whereIn('id', $userTags)->active()->select(['id', 'first_name', 'last_name'])->get();
                $userTags = json_encode($users);
                unset($users);
            } else {
                $userTags = '';
            }
        }
        $post = Post::create([
            'status' => $request->input('content'),
            'location_id' => $request->input('location_id'),
            'lat' => $request->input('lat'),
            'long' => $request->input('long'),
            'with_tags' => $userTags,
            'user_id' => \Authorizer::getResourceOwnerId()
        ]);
        $this->dispatch(new UpdateUserDropWhenCreatePost(\Authorizer::getResourceOwnerId(), $post->lat, $post->long));
        $this->dispatch(new IndexPostCreate($post));
        return $this->lzResponse->successTransformModel($post, new PostTransformer());
    }

	/**
	 * @SWG\Get(
	 *    path="/posts/list",
     *   summary="Get posts",
     *   tags={"Posts"},
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
	public function index(Request $request)
	{
        $page = $request->input('page', 1);
        $limit = $request->input('limit');

		$results = Post::getNewFeeds(\Authorizer::getResourceOwnerId(), $page, $limit);

        // format data
        $posts = $results['posts'];
        $friends = $results['friends'];
        unset($results);
        $data['paginator'] = [
            'total_count' => $posts->total(),
            'total_pages' => $posts->lastPage(),
            'current_page' => $posts->currentPage()
        ];

        $items = [];
        foreach ($posts->all() as $key => $post) {
            $items[$key] = $post->toArray();
            if (isset($items[$key]['user']) ) {
                if (array_key_exists($post->user->id, $friends)) {
                    $items[$key]['user']['friend_status'] = $friends[$post->user->id];
                } else {
                    $items[$key]['user']['friend_status'] = Friend::FRIEND_NO;
                }
            }
        }
        $data['items'] = $items;
		return $this->lzResponse->success($data);
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