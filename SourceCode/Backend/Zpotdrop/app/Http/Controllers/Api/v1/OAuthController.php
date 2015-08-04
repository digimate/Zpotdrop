<?php
/*
|--------------------------------------------------------------------------
| AOuthController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 ZPotDrop.
| @Date       : 7/29/15 - 3:13 PM
*/

namespace App\Http\Controllers\Api\v1;

use App\Http\Requests\UserRequest;
use Illuminate\Foundation\Auth\ThrottlesLogins;
use Illuminate\Foundation\Auth\AuthenticatesAndRegistersUsers;
use App\Acme\Models\User;
use Authorizer;
use Illuminate\Http\Request;
use Hashids;

/**
 * Class OAuthController
 * @package App\Http\Controllers\Api\v1
 */
/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="/Oauth",
 *    description="oauth2.0",
 *    produces="['application/json']"
 * )
 */
class OAuthController extends ApiController
{
	/*
    |--------------------------------------------------------------------------
    | Registration & Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users, as well as the
    | authentication of existing users. By default, this controller uses
    | a simple trait to add these behaviors. Why don't you explore it?
    |
    */

	use AuthenticatesAndRegistersUsers, ThrottlesLogins;

	/**
	 * OAuthController constructor.
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Create a new user instance after a valid registration.
	 *
	 * @param  array  $data
	 * @return User
	 */
	protected function create(array $data)
	{
		return User::create([
            'first_name'    => $data['first_name'],
            'last_name'     => $data['last_name'],
            'birthday'      => $data['birthday'],
			'email'         => $data['email'],
			'password'      => bcrypt($data['password']),
		]);
	}

	/**
	 * @SWG\Api(
	 *    path="/oauth/login",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Login",
	 *      @SWG\Parameter(
	 *			name="grant_type",
	 *			description="Grant type for Oauth2.0: password/refresh_token",
	 *			paramType="header",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 * 	            defaultValue="password",
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_id",
	 *			description="Client id: s6BhdRkqt3",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="s6BhdRkqt3"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_secret",
	 *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="7Fjfp0ZBr1KtDRbnfVdmIw"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="username",
	 *			description="Email",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="pisun2@gmail.com"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Plain password",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="123456"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Login successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function login($username, $password)
	{
		$validator = \Validator::make([$username, $password],[
			'username'=>'required',
			'password'=>'required'
		]);
		if($validator->fails()){
			return $this->lzResponse->badRequest($validator->errors()->all());
		}
		if (\Auth::attempt([
			'email'    => $username,
			'password' => $password]))
		{
			return \Auth::id();
		}
	}

	/**
	 * @SWG\Api(
	 *    path="/oauth/register",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Register new user",
	 *      @SWG\Parameter(
	 *			name="grant_type",
	 *			description="Grant type for Oauth2.0: password/refresh_token",
	 *			paramType="header",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 * 	            defaultValue="password",
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_id",
	 *			description="Client id: s6BhdRkqt3",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="s6BhdRkqt3"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_secret",
	 *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="7Fjfp0ZBr1KtDRbnfVdmIw"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="username",
	 *			description="Email",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="pisun2@gmail.com"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Plain password",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="123456"
	 *      	),
	 * 	    @SWG\Parameter(
	 *			name="email",
	 *			description="Email",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="pisun2@gmail.com"
	 *      	),
	 * 	    @SWG\Parameter(
	 *			name="first_name",
	 *			description="First Name",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="Phu"
	 *      	),
	 * 	    @SWG\Parameter(
	 *			name="last_name",
	 *			description="Last name",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="Nguyen"
	 *      	),
	 * 	    @SWG\Parameter(
	 *			name="birthday",
	 *			description="Birthday: dd-mm-YYYY",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="17-03-1988"
	 *      	),
	 * 	    @SWG\Parameter(
	 *			name="gender",
	 *			description="Gender: 0 male, 1: female, 2: others",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="0"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Register successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function register(UserRequest $request)
	{
		$user = $this->create($request->all());
		if($user){
			$user->update(
				[
					'hash' => Hashids::encode($user->id)
				]
			);
			return $this->lzResponse->success(Authorizer::issueAccessToken());
		}
	}

	/**
	 * @SWG\Api(
	 *    path="/oauth/logout",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Logout",
	 *      @SWG\Parameter(
	 *			name="grant_type",
	 *			description="Grant type for Oauth2.0: password/refresh_token",
	 *			paramType="header",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 * 	            defaultValue="password",
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_id",
	 *			description="Client id: s6BhdRkqt3",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="s6BhdRkqt3"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_secret",
	 *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="7Fjfp0ZBr1KtDRbnfVdmIw"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="access_token",
	 *			description="Access token",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 * 	 *		@SWG\ResponseMessage(code=200, message="Logout successful"),
	 *    )
	 * )
	 */
	public function logout(Request $request)
	{
		\Auth::logout();
		\Session::flush();
		$delete = \DB::table('oauth_access_tokens')->where('id', '=', $request->get('access_token'))->delete();
		if($delete){
			return $this->lzResponse->success([], 'Access token is revoked!');
		}
		return $this->lzResponse->badRequest(['Check your access_token again!!']);
	}
}