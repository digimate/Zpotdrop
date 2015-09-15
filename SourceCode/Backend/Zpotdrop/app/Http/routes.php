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

include 'Routes/Api.php';
include 'Routes/Common.php';