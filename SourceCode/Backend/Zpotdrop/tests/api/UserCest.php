<?php

class UserCest
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
    protected $email1 = 'test1@gmail.com';
    protected $email2 = 'test2@gmail.com';

    public function _before(ApiTester $I)
    {

    }

    public function _after(ApiTester $I)
    {
    }

    // tests
    public function getProfileTest(ApiTester $I)
    {
        $this->login($I, $this->email1);
        $response = $I->grabResponse();
        $response = json_decode($response);
        $this->getProfile($I,$response->data->id, $response->data->access_token);

    }


    private function getProfile(ApiTester &$I, $userId, $accessToken) {
        $I->wantTo("Get profile of userId={$userId}");
        $I->haveHttpHeader("Authorization", "Bearer ".$accessToken);
        $I->sendGET("users/profile/{$userId}/show", []);

        $I->seeResponseCodeIs(200);
        $I->seeResponseContainsJson(array('data' => array('id' => $userId)));
    }

    private function login(ApiTester &$I, $email){
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
