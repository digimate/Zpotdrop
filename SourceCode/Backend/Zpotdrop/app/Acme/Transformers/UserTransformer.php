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


use App\Acme\Models\User;

/**
 * Class UserTransformer
 * @package App\Models\Transformers
 */
class UserTransformer extends Transformer
{

	/**
	 * List of resources possible to include
	 *
	 * @var array
	 */
	protected $availableIncludes = [];

    protected $viewArr = ['id', 'email', 'avatar', 'first_name', 'last_name', 'birthday', 'gender', 'phone_number',
                          'home_town', 'is_private', 'is_enable_all_zpot', 'lat', 'long', 'status', 'follower_count', 'following_count', 'drop_count'];

    protected $privateView = ['id', 'avatar', 'first_name', 'last_name', 'is_private', 'follower_count', 'following_count', 'drop_count'];
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
	public function transform($user)
	{
        if (is_object($user->birthday)) {
            $user->birthday = $user->birthday->format('d-m-Y H:i:s');
        }

        if ($user instanceof User) {
            $user = $user->toArray();
        }

        if ($user['is_private'] == User::PROFILE_PUBLIC) {
            $arrUser = array_only($user, $this->viewArr);
        } else {
            $arrUser = array_only($user, $this->privateView);
        }

        $avatar = $arrUser['avatar'];
        unset($arrUser['avatar']);
        $arrUser['avatar_json'] = '';
        $arrUser['avatar_base64'] = '';
        if (!empty($avatar)) {
            $avatar = json_decode($avatar, true);
            if (is_array($avatar)) {
                $arrUser['avatar_base64'] = $avatar['base64'];
                unset($avatar['base64']);
                $arrUser['avatar_json'] = json_encode($avatar);
            }
        }
		return $arrUser;
	}

    /**
     * Turn this item object into a generic array
     *
     * @return array
     */
    public function transformPrivate(User $user)
    {
        $arrUser = array_only($user->toArray(), ['id', 'hash', 'is_private', 'is_enable_all_zpot', 'status',
            'follower_count', 'following_count', 'drop_count', 'avatar']);
        return $arrUser;
    }
}