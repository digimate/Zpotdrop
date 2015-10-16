<?php
include 'BaseCest.php';

class UserCest extends BaseCest
{

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

}
