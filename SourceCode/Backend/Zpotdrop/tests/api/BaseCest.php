<?php

class BaseCest {
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
    protected $email1 = 'test1@gmail.com';
    protected $email2 = 'test2@gmail.com';


    protected function login(ApiTester &$I, $email){
        $I->wantTo('Login with email '.$email);
        $form = array_merge($this->oauth_form,
            [
                'username'  => $email,
                'password'  => '123456',
            ]);
        $I->sendPOST($this->endpoint . 'login', $form);
        $I->seeResponseCodeIs(200);
        $I->seeResponseIsJson();
        $I->expect('see token of this user');
        $I->seeResponseContainsJson(array('data' => array('token_type' => 'Bearer')));
    }
}