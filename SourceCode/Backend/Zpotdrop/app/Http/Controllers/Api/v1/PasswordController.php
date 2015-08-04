<?php
/*
|--------------------------------------------------------------------------
| PasswordController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 ZPotDrop.
| @Date       : 7/29/15 - 3:13 PM
*/

namespace App\Http\Controllers\Api\v1;

use App\Jobs\SendReminderEmail;
use Illuminate\Foundation\Auth\ResetsPasswords;
use Illuminate\Http\Request;
use Illuminate\Mail\Message;
use Validator;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * @SWG\Resource(
 *    apiVersion="1.0",
 *    resourcePath="/Oauth",
 *    description="oauth2.0",
 *    produces="['application/json']"
 * )
 */
class PasswordController extends ApiController
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset requests
    | and uses a simple trait to include this behavior. You're free to
    | explore this trait and override any methods you wish to tweak.
    |
    */

    use ResetsPasswords;


	/**
	 * PasswordController constructor.
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Send a reset link to the given user.
	 *
	 * @param  \Illuminate\Http\Request $request
	 * @return \Illuminate\Http\Response
	 */
	/**
	 * @SWG\Api(
	 *    path="/oauth/password/remind",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Remind password",
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
	 *			name="email",
	 *			description="Email",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="pisun2@gmail.com"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Message sent to your email!"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function remindPassword(Request $request)
	{
		$validator = Validator::make($request->all(), ['email' => 'required|email']);

		if($validator->fails()){
			return $this->lzResponse->badRequest($validator->errors()->all());
		}

		$job = (new SendReminderEmail(['email'=>$request->get('email')]))->onQueue('emails');
		$this->dispatch($job);
		$job->delete();

		return $this->lzResponse->success(trans('Password reset link sent to your email!'));
	}

	/**
	 * @param null $token
	 * @return $this
	 * @throws NotFoundHttpException
	 */
	public function getReset($token = null)
	{
		if (is_null($token)) {
			throw new NotFoundHttpException;
		}

		return view('auth.reset')->with('token', $token);
	}

	/**
	 * Reset the given user's password.
	 *
	 * @param  \Illuminate\Http\Request $request
	 * @return \Illuminate\Http\Response
	 */
	public function postReset(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'token' => 'required',
			'email' => 'required|email',
			'password' => 'required|confirmed',
		]);

		if($validator->fails()){
			return view('auth.resetResult', ['errors'=>$validator->errors()->all()]);
		}

		$credentials = $request->only(
			'email', 'password', 'password_confirmation', 'token'
		);

		$response = \Password::reset($credentials, function ($user, $password) {
			$this->resetPassword($user, $password);
		});

		switch ($response) {
			case \Password::PASSWORD_RESET:
				return view('auth.resetResult',
					['message' => trans($response)]);

			default:
				return view('auth.resetResult',
					['email' => trans($response)]);
		}
	}

	/**
	 * @SWG\Api(
	 *    path="/oauth/password/change",
	 *      @SWG\Operation(
	 *        method="POST",
	 *        summary="Request change password",
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
	 *      @SWG\Parameter(
	 *			name="password",
	 *			description="Password",
	 *			paramType="form",
	 *      		required=true,
	 *      		allowMultiple=false,
	 *      		type="string",
	 *              defaultValue="1234567"
	 *      	),
	 *		@SWG\ResponseMessage(code=200, message="Password changed!"),
	 *      @SWG\ResponseMessage(code=400, message="Bad request")
	 *    )
	 * )
	 */
	public function postChangePassword(Request $request)
	{
		if(\Auth::guest()){
			return $this->lzResponse->unauthorized();
		}
		$validator = Validator::make($request->all(), ['password' => 'required|min:6']);
		if($validator->fails()){
			return $this->lzResponse->badRequest($validator->errors()->all());
		}
		$this->resetPassword(\Auth::user(), $request->get('password'));
		return $this->lzResponse->success([], 'Password Changed!');
	}

}
