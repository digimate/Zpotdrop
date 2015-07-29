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

use App\Acme\Restful\LZResponse;
use Illuminate\Http\Request;
use Validator;
use Illuminate\Foundation\Auth\ThrottlesLogins;
use Illuminate\Foundation\Auth\AuthenticatesAndRegistersUsers;
use App\Models\User;
use Authorizer;


/**
 * Class OAuthController
 * @package App\Http\Controllers\Api\v1
 */
/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="/oauth",
 *    description="OAuth",
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

	protected $lzResponse;
	/**
	 * OAuthController constructor.
	 */
	public function __construct()
	{
		$this->middleware('guest', ['except' => 'getLogout']);
		$this->lzResponse = new LZResponse();
	}

	/**
	 * Get a validator for an incoming registration request.
	 *
	 * @param  array  $data
	 * @return \Illuminate\Contracts\Validation\Validator
	 */
	protected function validator(array $data)
	{
		return Validator::make($data, [
            'first_name'    => 'required|max:255',
            'last_name'     => 'required|max:255',
            'birthday'      => 'required|date',
            'gender'        => 'required|max:1',
			'email'         => 'required|email|max:255|unique:users',
			'password'      => 'required|min:6',
		]);
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
	 *    path="/users/login",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Login",
	 *      @SWG\Parameter(
	 *			name="email",
	 *			description="Email register",
	 *			paramType="query",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Plain password",
	 *			paramType="query",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Login successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function login($username, $password)
	{
		if(empty(\Input::get('email')) || empty(\Input::get('password'))){

			return $this->lzResponse->badRequest();
		}

		$credentials = [
			'email'    => $username,
			'password' => $password,
		];
		if (\Auth::attempt($credentials)) {
			return \Auth::id();
		}
		return false;
	}

	/**
	 * @SWG\Api(
	 *    path="/oauth/register",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Register new user",
	 *      @SWG\Parameter(
	 *			name="email",
	 *			description="Email register",
	 *			paramType="query",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Plain password",
	 *			paramType="query",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Register successful"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function register(Request $request)
	{
		if(\Auth::check()){
			return $this->lzResponse->success([
				'token' => Authorizer::issueAccessToken(),
			]);
		}
		$validate = $this->validator($request->all());
		if(!$validate->fails()){
			$user = $this->create($request->all());
			if($user){
				\Auth::login($user);
				return $this->lzResponse->success([
					'token' => Authorizer::issueAccessToken(),
					'user'  => $user
				]);
			}
		}
		return $this->lzResponse->badRequest($validate->errors()->all());
	}


	/**
	 * @SWG\Api(
	 *    path="/users/logout",
	 *      @SWG\Operation(
	 *        method="GET",
	 *        summary="Logout",
	 *      @SWG\Parameter(
	 *			name="token",
	 *			description="token of user after logged in",
	 *			paramType="query",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Logout successful"),
	 *    )
	 * )
	 */
	public function logout()
	{
		\Auth::logout();
		\Session::clear();
	}
}