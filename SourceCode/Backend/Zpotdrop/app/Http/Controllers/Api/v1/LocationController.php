<?php
/*
|--------------------------------------------------------------------------
| ZpotController.php
|--------------------------------------------------------------------------
| @Author     : Nhieu Nguyen
| @Email      : nhieunguyenkhtn@gmail.com
| @Copyright  : © 2015 ZpotDrop.
| @Date       :
*/

namespace App\Http\Controllers\Api\v1;


use App\Acme\Images\LZImage;
use App\Acme\Models\Friend;
use App\Acme\Models\Location;
use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Acme\Restful\LZResponse;
use App\Acme\Transformers\FriendTransformer;
use App\Acme\Transformers\LocationTransformer;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Image\Upload;
use App\Events\UserFollowEvent;
use App\Http\Requests\LocationRequest;
use App\Http\Requests\LocationSearchRequest;
use App\Http\Requests\UserUpdateRequest;
use App\Jobs\IndexRegisterLocation;
use Illuminate\Http\Request;

class LocationController extends ApiController
{
	/**
	 * @SWG\Post(
	 *    path="/geo/location",
     *   summary="Add new location",
     *   tags={"Location"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     *      @SWG\Parameter(
     *			name="name",
     *			description="Name of location",
     *			in="formData",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="address",
     *			description="Location's address",
     *			in="formData",
     *      	required=true,
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
	public function add(LocationRequest $request)
	{
        $location = Location::create(array_merge($request->only(['name', 'address', 'lat', 'long']), ['user_id' => \Authorizer::getResourceOwnerId()]));
        //$this->dispatch(new IndexRegisterLocation($location));
        return $this->lzResponse->successTransformModel($location, new LocationTransformer());
	}


    /**
     * @SWG\get(
     *    path="/geo/locations",
     *   summary="Get location",
     *   tags={"Location"},
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="lat",
     *			description="Current latitude",
     *			in="query",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="long",
     *			description="Current longitude",
     *			in="query",
     *      	required=true,
     *      	type="string"
     *      	),
     *      @SWG\Parameter(
     *			name="distance",
     *			description="Radius to search . Default 1km",
     *			in="query",
     *      	type="integer"
     *      	),
     *      @SWG\Parameter(
     *			name="keyword",
     *			description="Search keyword",
     *			in="query",
     *      	type="string"
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
     *			description="Number of post want to get : min=1 ; max=500",
     *			in="query",
     *      	required=true,
     *      	type="integer"
     *      	),
     *		@SWG\Response(response=200, description="Register successful"),
     *      @SWG\Response(response=400, description="Bad request")
     *
     * )
     */
    public function locations(LocationSearchRequest $request)
    {
        $page = $request->get('page', 1);
        $limit = $request->get('limit');
        $distance = $request->get('distance');
        $keyword = $request->get('keyword');
        $latitude = $request->get('lat');
        $longitude = $request->get('long');

        $locations = Location::getLocations($keyword, $distance, $latitude, $longitude, $page, $limit);

        return $this->lzResponse->successTransformArrayModelsWithPagination($locations, new LocationTransformer());
    }

}