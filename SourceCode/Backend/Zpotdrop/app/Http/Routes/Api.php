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
	Route::group(['namespace'=>'Api\v1', 'middleware' => 'oauth'], function(){
		/*users*/

		/*Friend*/
		Route::group(['prefix'=>'friends'], function(){
			Route::resource('friends', 'FriendController');
			Route:get('friends/{id}/delete', 'FriendController@delete');
		});

		/*posts*/
		Route::group(['prefix'=>'posts'], function(){
			Route::get('/list', ['as' => 'api.posts.list', 'uses' => 'PostController@index']);
			Route::get('{id}/show', ['as' => 'api.posts.show', 'uses' => 'PostController@show']);
			Route::get('{id}/like', ['as' => 'api.posts.like', 'uses' => 'PostController@like']);
		});
	});
});

/*Authenticate Route*/
Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace'=>'Api\V1'], function(){
		Route::post('oauth/register', ['as'=>'oauth.register', 'uses' => 'OAuthController@register']);
		Route::get('oauth/logout', ['as'=>'oauth.logout', 'uses' => 'OAuthController@logout']);

		Route::post('oauth/login', function() {
			$lzResponse = new \App\Acme\Restful\LZResponse();
			return $lzResponse->success(Authorizer::issueAccessToken());
		});
	});
});

/*API table document*/
Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace'=>'Api\v1'], function(){
		Route::get('tables/users', 'TableController@users');
		Route::get('tables/friends', 'TableController@friends');
		Route::get('tables/posts', 'TableController@posts');
		Route::get('tables/likes', 'TableController@likes');
		Route::get('tables/comments', 'TableController@comments');
	});
});