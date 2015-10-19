<?php
/*
|--------------------------------------------------------------------------
| UsersController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 1:45 PM
*/

namespace App\Http\Controllers\Api\v1;


use App\Acme\Images\LZImage;
use App\Acme\Models\User;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Image\Upload;
use App\Http\Requests\UserUpdateRequest;

class UserController extends ApiController
{
	/**
	 * @SWG\Get(
	 *    path="/users/profile/{id}/show",
     *   summary="Get detail profile of ID",
     *   tags={"Users"},
	 *     @SWG\Parameter(
	 *			name="id",
	 *			description="ID of user",
	 *			in="query",
	 *      	required=true,
	 *      	type="integer"
	 *      	),
     *     @SWG\Parameter(
     *			name="Authorization",
     *			description="Authorization include  Bearer & access_token ex: Bearer rAPoKnrkC87f9ex9oh0WZ1iUMBhLMBHXGrgrWW1f",
     *			in="header",
     *      	required=true,
     *      	type="integer"
     *      	),
	 *		@SWG\Response(response=200, description="Profile of user"),
	 *      @SWG\Response(response=400, description="Bad request")
	 *    
	 * )
	 */
	public function show($id)
	{
		$user = User::find($id);
		if($user)
		{
            // if the user set his profile is private
            if ($user->is_private == User::PROFILE_PRIVATE && $id != \Authorizer::getResourceOwnerId()) {
                $transformer = new UserTransformer();
                return $this->lzResponse->success($transformer->transformPrivate($user));
            }
            // profile is public
			return $this->lzResponse->successTransformModel($user, new UserTransformer());
		}
		return $this->lzResponse->badRequest();
	}

	/**
	 * @SWG\Post(
	 *    path="/users/profile/update",
     *    summary="Show detail profile for edit",
     *    tags={"Users"},
     *      @SWG\Parameter(
     *			name="access_token",
     *			description="access_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *      	),
     * 	    @SWG\Parameter(
     *			name="first_name",
     *			description="First Name",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="Phu"
     *      	),
     * 	    @SWG\Parameter(
     *			name="last_name",
     *			description="Last name",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="Nguyen"
     *      	),
     * 	    @SWG\Parameter(
     *			name="birthday",
     *			description="Birthday: dd-mm-YYYY",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="17-03-1988"
     *      	),
     * 	    @SWG\Parameter(
     *			name="gender",
     *			description="Gender: 0 male, 1: female, 2: others",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="0",
     *              maximum="2",
     *              minimum="0"
     *      	),
     * 	    @SWG\Parameter(
     *			name="phone_number",
     *			description="Phone number",
     *			in="formData",
     *      	type="string",
     *          default=""
     *      	),
     * 	    @SWG\Parameter(
     *			name="is_private",
     *			description="Profile setting : 0=private; 1=public",
     *			in="formData",
     *      	type="integer",
     *          default="0",
     *          minimum="0",
     *          maximum="1"
     *      	),
     * 	    @SWG\Parameter(
     *			name="is_enable_all_zpot",
     *			description="Profile setting : 0=disable; 1=enable",
     *			in="formData",
     *      	type="integer",
     *          default="0",
     *          minimum="0",
     *          maximum="1"
     *      	),
     * 	    @SWG\Parameter(
     *			name="avatar",
     *			description="Avatar",
     *			in="formData",
     *      	type="file",
     *          default=""
     *      	),
	 *		@SWG\Response(response=200, description="Profile of current user"),
	 *
	 * )
	 */
	public function update(UserUpdateRequest $request)
	{
        $user = new User();
        $user = $user->find(\Authorizer::getResourceOwnerId());
        $old_avatar = $user->avatar;
        $postData = $request->all();
        array_forget($postData, 'email', 'password', 'status', 'hash', 'role');
        $user->fill($postData);

        /*Avatar come here*/
        if($request->hasFile('avatar') && $request->file('avatar')->isValid()){
            $uploads = Upload::process($_FILES['avatar'], public_path(config('custom.upload_dir')));
            if ($uploads['error'] == 0) {
                $user->avatar = json_encode($uploads['data']);
            }
            /*delete old avatar*/
            if (!empty($old_avatar))
                LZImage::delete($old_avatar);
        }
        if($user->update()){
            return $this->lzResponse->successTransformModel($user, new UserTransformer());
        }
        return $this->lzResponse->badRequest();
	}

	public function feeds($friend_id)
	{
	}
}