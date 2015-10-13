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

use App\Acme\Models\UserMailVerify;
use App\Acme\Transformers\UserTransformer;
use App\Acme\Utils\Hash;
use App\Acme\Utils\Time;
use App\Http\Requests\UserRequest;
use App\Jobs\SendRegisterConfirmEmail;
use Illuminate\Foundation\Auth\ThrottlesLogins;
use Illuminate\Foundation\Auth\AuthenticatesAndRegistersUsers;
use App\Acme\Models\User;
use Authorizer;
use Illuminate\Http\Request;
use Hashids;
use League\OAuth2\Server\Exception\InvalidCredentialsException;

/**
 * Class OAuthController
 * @package App\Http\Controllers\Api\v1
 */
/**
 * @SWG\Swagger(
 *  info={
 *     "title": "Zpotdrop Api",
 *      "description": "",
 *      "version": "1.0.1"
 *   },
 *  basePath="/api/v1",
 *  produces={"application/json"},
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
            'hash'          => Hash::hexId(),
            'phone_number'  => isset($data['phone_number'])? $data['phone_number'] : '',
            'status'        => User::STATUS_INACTIVE,
            'is_private'    => isset($data['is_private']) ? $data['is_private'] : User::PROFILE_PRIVATE ,
            'is_enable_all_zpot' => isset($data['is_enable_all_zpot']) ? $data['is_enable_all_zpot'] : User::ZPOT_ALL_DISABLE,
            'lat'           => isset($data['lat']) ? $data['lat'] : '',
            'long'          => isset($data['long']) ? $data['long'] : '',
            'device_id'     => isset($data['device_id']) ? $data['device_id'] : '',
            'device_name'   => isset($data['device_name']) ? $data['device_name'] : '',
            'device_type'   => isset($data['device_type']) ? $data['device_type'] : ''
		]);
	}

	/**
	 * @SWG\Post(
	 *    path="/oauth/login",
     *   summary="Login",
     *   tags={"OAuth"},
	 *      @SWG\Parameter(
	 *			name="grant_type",
	 *			description="Grant type for Oauth2.0: password/refresh_token",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 * 	        default="password",
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_id",
	 *			description="Client id: s6BhdRkqt3",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="s6BhdRkqt3"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="client_secret",
	 *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="7Fjfp0ZBr1KtDRbnfVdmIw"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="username",
	 *			description="Email",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="pisun2@gmail.com"
	 *      	),
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Plain password",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="123456"
	 *      	),
     * 	    @SWG\Parameter(
     *			name="device_id",
     *			description="Device id",
     *			in="formData",
     *      	required=true,
     *      	type="string",
     *          default=""
     *      	),
     * 	    @SWG\Parameter(
     *			name="device_type",
     *			description="Device type : 0 iphone, 1 android",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="0"
     *      	),
     * 	    @SWG\Parameter(
     *			name="lat",
     *			description="Latitude",
     *			in="formData",
     *      	type="string",
     *          default=""
     *      	),
     * 	    @SWG\Parameter(
     *			name="long",
     *			description="Longitude",
     *			in="formData",
     *      	type="string",
     *          default=""
     *      	),
	 *		@SWG\Response(response=200, description="Login successful"),
	 *      @SWG\Response(response=400, description="Bad request")
	 * )
	 */
	public function login(Request $request)
	{
		$this->validate($request, [
			'username' => 'required',
            'password' => 'required',
            'lat' => 'required|numeric',
            'long'  => 'required|numeric',
            'device_type' => 'required|integer|in:0,1',
            'device_id' => 'required'
		]);

		// If the class is using the ThrottlesLogins trait, we can automatically throttle
		// the login attempts for this application. We'll key this by the username and
		// the IP address of the client making these requests into this application.
		$throttles = $this->isUsingThrottlesLoginsTrait();

		if ($throttles && $this->hasTooManyLoginAttempts($request)) {
			return $this->sendLockoutResponse($request);
		}

//        try {
            $token = Authorizer::issueAccessToken();
//        } catch(InvalidCredentialsException $ex) {
//            return $this->lzResponse->badRequest($this->getFailedLoginMessage());
//        } catch(\Exception $ex) {
//            \Log::error($ex->getMessage(), $ex->getTrace());
//            return $this->lzResponse->badRequest($this->getFailedLoginMessage());
//        }

        if ($token) {
            $user = \Auth::user();
            $user->lat = $request->input('lat');
            $user->long = $request->input('long');
            $user->device_id = $request->input('device_id');
            $user->device_type = $request->input('device_type');
            $user->save();

            $transformer = new UserTransformer();
            return $this->lzResponse->success(array_merge($token, $transformer->transform($user)));
        }
		// If the login attempt was unsuccessful we will increment the number of attempts
		// to login and redirect the user back to the login form. Of course, when this
		// user surpasses their maximum number of attempts they will get locked out.
		if ($throttles) {
			$this->incrementLoginAttempts($request);
		}

		return $this->lzResponse->badRequest($this->getFailedLoginMessage());
	}

    public function verify($username, $password)
    {
        $credentials = [
            'email'    => $username,
            'password' => $password,
            'status'   => 1
        ];
        if (\Auth::once($credentials)) {
            return \Auth::id();
        }

        return false;
    }


    /**
     * @SWG\Post(
     *   path="/oauth/register",
     *   summary="Register new user",
     *   tags={"OAuth"},
     *      @SWG\Parameter(
     *			name="grant_type",
     *			description="Grant type for Oauth2.0: password/refresh_token",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     * 	            default="password",
     *      	),
     *      @SWG\Parameter(
     *			name="client_id",
     *			description="Client id: s6BhdRkqt3",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="s6BhdRkqt3"
     *      	),
     *      @SWG\Parameter(
     *			name="client_secret",
     *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="7Fjfp0ZBr1KtDRbnfVdmIw"
     *      	),
     *      @SWG\Parameter(
     *			name="password",
     *			description="Plain password",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="123456"
     *      	),
     * 	    @SWG\Parameter(
     *			name="email",
     *			description="Email",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="pisun2@gmail.com"
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
     *			name="phone_number",
     *			description="Phone's number",
     *			in="formData",
     *      		type="string",
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
     *			name="device_id",
     *			description="Device id",
     *			in="formData",
     *      	required=true,
     *      	type="string",
     *          default=""
     *      	),
     * 	    @SWG\Parameter(
     *			name="device_type",
     *			description="Device type : 0 iphone, 1 android",
     *			in="formData",
     *      		required=true,
     *      		type="string",
     *              default="0"
     *      	),
     * 	    @SWG\Parameter(
     *			name="lat",
     *			description="Latitude",
     *			in="formData",
     *      	required=true,
     *      	type="string",
     *          default=""
     *      	),
     * 	    @SWG\Parameter(
     *			name="long",
     *			description="Longitude",
     *			in="formData",
     *      	required=true,
     *      	type="string",
     *          default=""
     *      	),
     *   @SWG\Response(
     *     response=200,
     *     description="Register successful"
     *   ),
     *   @SWG\Response(
     *     response="400",
     *     description="Bad request"
     *   )
     * )
     */
	public function register(UserRequest $request)
	{
		$user = $this->create($request->all());
		if($user){
            $this->dispatch(new SendRegisterConfirmEmail($user));
            return $this->lzResponse->success();
            /*$transformer = new UserTransformer();
            $user = $transformer->transform($user);
			return $this->lzResponse->success(array_merge($user, Authorizer::issueAccessToken()));*/
		}
	}

	/**
	 * @SWG\Post(
	 *    path="/oauth/logout",
     *    summary="Logout",
     *    tags={"OAuth"},
	 *    @SWG\Parameter(
	 *			name="grant_type",
	 *			description="Grant type for Oauth2.0: password/refresh_token",
	 *			in="header",
	 *      		required=true,
	 *      		type="string",
	 * 	            default="password",
	 *      	),
	 *    @SWG\Parameter(
	 *			name="client_id",
	 *			description="Client id: s6BhdRkqt3",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="s6BhdRkqt3"
	 *      	),
	 *    @SWG\Parameter(
	 *			name="client_secret",
	 *			description="Client secret: 7Fjfp0ZBr1KtDRbnfVdmIw",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string",
	 *          default="7Fjfp0ZBr1KtDRbnfVdmIw"
	 *      	),
	 *    @SWG\Parameter(
	 *			name="access_token",
	 *			description="Access token",
	 *			in="formData",
	 *      	required=true,
	 *      	type="string"
	 *      	),
	 * 	 @SWG\Response(response=200, description="Logout successful")
	 * )
	 */
	public function logout(Request $request)
	{
		parent::getLogout();
		\Auth::logout();
		\Session::flush();
		$delete = \DB::table('oauth_access_tokens')->where('id', '=', $request->get('access_token'))->delete();
		if($delete){
			return $this->lzResponse->success([], 'Access token is revoked!');
		}
		return $this->lzResponse->badRequest(['Check your access_token again!!']);
	}

    /**
     * @param Request $request
     * @param $token
     * @return \Illuminate\View\View
     */
    public function confirmRegister(Request $request, $token) {
        $code = UserMailVerify::where('code', $token)->first();
        $error = 0;
        if ( !$code || (strtotime($code->expired_at) < Time::getDateTime()->getTimestamp()) ) {
            $message = trans('mail.token_expired');
            $error = 1;
        } else {
            \DB::table('users')->where('id', $code->user_id)
                ->update(['status' => User::STATUS_ACTIVE]);
            $code->delete();
            $message = trans('mail.active_success');
        }
        return view('auth.active-account', ['error' => $error, 'message' => $message]);
    }
}