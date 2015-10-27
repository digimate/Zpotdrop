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
use App\Acme\Models\Friend;
use App\Acme\Models\Like;


/**
 * Class FriendTransformer
 * @package App\Models\Transformers
 */
class LikeTransformer extends Transformer
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
	public function transform(Like $like)
	{
        $like = $like->toArray();
		return $like['user'];
	}

	/**
	 * @param Friend $friend
	 * @return \League\Fractal\Resource\Item
	 */
	public function includeUser(Friend $friend)
	{
		$user = $friend->user;
		return $this->item($user, new UserTransformer());
	}
}