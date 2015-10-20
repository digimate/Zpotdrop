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


/**
 * Class FriendTransformer
 * @package App\Models\Transformers
 */
class FriendTransformer extends Transformer
{

	/**
	 * List of resources possible to include
	 *
	 * @var array
	 */
	protected $availableIncludes = ['user'];

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
	public function transform(Friend $friend)
	{
        $friend = $friend->toArray();

		$arrFriend = [
            'status' => $friend['is_friend'],
            'updated_at' => $friend['updated_at'],
        ];
        if (isset($friend['user'])) {
            $arrFriend['followers'] = $this->getUser($friend['user']);
        }
        if (isset($friend['friend'])) {
            $arrFriend['followings'] = $this->getUser($friend['friend']);
        }

		return $arrFriend;
	}

    public function getUser(array $friend) {
        return [
            'user_id' => $friend['id'],
            'avatar'  => $friend['avatar'],
            'first_name' => $friend['first_name'],
            'last_name' => $friend['last_name']
        ];
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