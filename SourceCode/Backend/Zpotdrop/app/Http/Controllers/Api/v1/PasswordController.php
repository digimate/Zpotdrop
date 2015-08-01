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

use Illuminate\Foundation\Auth\ResetsPasswords;
use Illuminate\Http\Request;
use Illuminate\Mail\Message;
use Validator;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

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
	public function remindPassword(Request $request)
	{
		$validator = Validator::make($request->all(), ['email' => 'required|email']);

		if($validator->errors()){
			return $this->lzResponse->badRequest($validator->errors()->all());
		}

		$response = \Password::sendResetLink($request->only('email'), function (Message $message) {
			$message->subject($this->getEmailSubject());
		});

		switch ($response) {
			case \Password::RESET_LINK_SENT:
				return $this->lzResponse->success(trans($response));

			case \Password::INVALID_USER:
				return $this->lzResponse->badRequest(trans($response));
		}
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

		if($validator->errors()){
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

	public function postChangePassword(Request $request)
	{
		if(\Auth::guest()){
			return $this->lzResponse->unauthorized();
		}
		$validator = Validator::make($request->all(), ['email' => 'required|email']);
		if($validator->errors()){
			return $this->lzResponse->badRequest($validator->errors()->all());
		}
		$this->resetPassword(\Auth::user(), $request->get('password'));
		return $this->lzResponse->success();
	}

}
