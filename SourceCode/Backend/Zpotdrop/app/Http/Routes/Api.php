<?php

/*
|--------------------------------------------------------------------------
| Api Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace'=>'Api\v1'], function(){
		Route::resource('users', 'UsersController');
		Route::resource('friends', 'FriendsController');
		Route:get('friends/{id}/delete', 'FriendsController@delete');

		Route::group(['prefix'=>'posts'], function(){
			Route::get('/list', ['as' => 'api.posts.list', 'uses' => 'PostsController@index']);
			Route::get('{id}/show', ['as' => 'api.posts.show', 'uses' => 'PostsController@show']);
			Route::get('{id}/like', ['as' => 'api.posts.like', 'uses' => 'PostsController@like']);
		});
	});
});