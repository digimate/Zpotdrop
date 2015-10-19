<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/', function () {
    return Redirect::to('api-docs');
});

Route::get('tests/redis', 'TestController@redis');
Route::get('tests/beanstalk', 'TestController@beanstalk');

Route::group(['namespace' => 'Api\v1'], function() {
    Route::get('oauth/register/verify/{token}', ['as' =>  'frontend.register.verify', 'uses' => 'OAuthController@confirmRegister']);
    Route::get('oauth/password/reset/{token}', [
        'as' => 'oauth.password.get.reset',
        'uses' => 'PasswordController@getReset'
    ]);
    Route::post('oauth/password/reset', [
        'as' => 'oauth.password.post.reset',
        'uses' => 'PasswordController@postReset'
    ]);
});



include 'Routes/Api.php';
include 'Routes/Common.php';