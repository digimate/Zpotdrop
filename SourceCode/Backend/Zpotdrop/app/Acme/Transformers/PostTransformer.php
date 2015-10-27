<?php
/*
|--------------------------------------------------------------------------
| UserTransformer.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/30/15 - 5:56 PM
*/

namespace App\Acme\Transformers;


use App\Acme\Models\Post;

/**
 * Class UserTransformer
 * @package App\Models\Transformers
 */
class PostTransformer extends Transformer
{

	/**
	 * List of resources possible to include
	 *
	 * @var array
	 */
	protected $availableIncludes = [];

	/**
	 * @var array
	 */
	protected $defaultIncludes = [];

	/**
	 * UserTransformer constructor.
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Turn this item object into a generic array
	 *
	 * @return array
	 */
	public function transform(Post $post)
	{
		$arrPost = $post->toArray();
		return $arrPost;
	}

	/**
	 * @param Post $post
	 * @return \League\Fractal\Resource\Item
	 */
	public function includeUser(Post $post)
	{
		$user = $post->user;
		return $this->item($user, new UserTransformer());
	}
}