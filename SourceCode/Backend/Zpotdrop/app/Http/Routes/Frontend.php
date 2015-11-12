<?php


Route::get('auth/login', 'Auth\AuthController@getLogin');
Route::post('auth/login', 'Auth\AuthController@postLogin');
Route::get('auth/logout', 'Auth\AuthController@getLogout');


Route::group(['middleware' => 'auth'], function () {
    Route::get('chat', function () {
        $page = 1;
        $limit = 20;
        $friends = \App\Acme\Models\Friend::getFriends(Auth::id(), '', $page, $limit);


        return view('chat.index', compact('friends'));
    });
});