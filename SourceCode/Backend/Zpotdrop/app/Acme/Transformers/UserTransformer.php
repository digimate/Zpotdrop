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
                          'home_town', 'is_private', 'is_enable_all_zpot', 'lat', 'long', 'status'];

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
	public function transform(User $user)
	{
		$arrUser = array_only($user->toArray(), $this->viewArr);
		return $arrUser;
	}
}