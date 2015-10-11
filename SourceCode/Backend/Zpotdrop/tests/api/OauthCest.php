<?php

class OauthCest
{
	protected $endpoint = 'oauth/';
	protected $oauth_form = [
		'client_id'     => 's6BhdRkqt3',
		'client_secret' => '7Fjfp0ZBr1KtDRbnfVdmIw',
        'grant_type' => 'password',
        'device_id' => '2255625855',
        'device_type' => 0,
        'lat' => 10,
        'long' => 12
	];
	protected $email = 'pisun34@gmail.com';

    public function _before(ApiTester $I)
    {
	    $I->haveHttpHeader('grant_type', 'password');
    }

    public function _after(ApiTester $I)
    {
    }

    // tests
	public function registerUser(ApiTester $I)
	{
		$form = array_merge($this->oauth_form, [
			'username'  => $this->email,
			'password'  => '123456',
			'email'     => $this->email,
			'first_name'=> 'Phu',
			'last_name' => 'Nguyen',
			'birthday'  => '17-03-1988',
			'gender'    => '0',
            'phone_number' => '',
		]);
		$I->sendPOST($this->endpoint . 'register', $form);
		$I->seeResponseCodeIs(200);
		/*$I->seeResponseIsJson();
		$I->expect('see the token of this user');
		$I->seeResponseContainsJson([
			'expires_in' => 3600,
		]);*/
	}

	public function registerUserMissingParam(ApiTester $I)
	{
		$form = array_merge($this->oauth_form, [
			'username'  => $this->email,
			'password'  => '123456',
			'first_name'=> 'Phu',
			'birthday'  => '17-03-1988',
			'gender'    => '0'
		]);
		$I->sendPOST($this->endpoint . 'register', $form);
		$I->seeResponseCodeIs(400);
		$I->seeResponseIsJson();
		$I->expect('see errors array');
		$I->canSeeResponseContainsJson([
			'The email field is required.',
			'The last name field is required.'
		]);
	}


	public function loginWithEmailSuccess(ApiTester $I)
	{
        $form = array_merge($this->oauth_form, [
            'username'  => $this->email,
            'password'  => '123456',
            'email'     => $this->email,
            'first_name'=> 'Phu',
            'last_name' => 'Nguyen',
            'birthday'  => '17-03-1988',
            'gender'    => '0',
            'phone_number' => '',
        ]);
        $I->sendPOST($this->endpoint . 'register', $form);


        $user = \App\Acme\Models\User::where('email', $this->email)->first();
        $user->status = 1;
        $user->save();

		$form = array_merge($this->oauth_form,
			[
				'username'  => $this->email,
				'password'  => '123456',
			]);
		$I->sendPOST($this->endpoint . 'login', $form);
		$I->seeResponseCodeIs(200);
		$I->seeResponseIsJson();
		$I->expect('see token of this user');
		$I->seeResponseContainsJson(['expires_in' => 3600]);
	}

	public function loginWithEmailFail(ApiTester $I)
	{
		$form = array_merge($this->oauth_form,
			[
				'username'  => $this->email,
				'password'  => 'dasdsdad',
			]);
		$I->sendPOST($this->endpoint . 'login', $form);
		$I->comment($I->grabResponse());
		$I->cantSeeAuthentication();
		$I->seeResponseCodeIs(401);
		$I->seeResponseIsJson();
		$I->canSeeResponseContainsJson(['message' => 'The user credentials were incorrect.']);
	}
}