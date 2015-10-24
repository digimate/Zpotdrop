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


use App\Acme\Models\Location;
use App\Acme\Models\User;

/**
 * Class LocationTransformer
 * @package App\Models\Transformers
 */
class LocationTransformer extends Transformer
{

	/**
	 * List of resources possible to include
	 *
	 * @var array
	 */
	protected $availableIncludes = [];

    protected $viewArr = ['id', 'name', 'address', 'lat', 'long'];

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
	public function transform($location)
	{
        if ($location instanceof Location) {
            $location = $location->toArray();
        }
		return array_only($location, $this->viewArr);
	}
}