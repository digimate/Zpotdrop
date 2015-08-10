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

/*
|--------------------------------------------------------------------------
| Dont need Oauth2
|--------------------------------------------------------------------------
*/
Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace'=>'Api\v1'], function(){
		Route::post('oauth/register', [
			'as' => 'oauth.register',
			'uses' => 'OAuthController@register'
		]);
		Route::post('oauth/login', function() {
			$lzResponse = new \App\Acme\Restful\LZResponse();
			return $lzResponse->success(Authorizer::issueAccessToken());
		});
/*
|--------------------------------------------------------------------------
| Password
|--------------------------------------------------------------------------
*/
		Route::post('oauth/password/remind', 'PasswordController@remindPassword');
		Route::get('oauth/password/reset/{token}', [
			'as' => 'oauth.password.get.reset',
			'uses' => 'PasswordController@getReset'
		]);
		Route::post('oauth/password/reset', [
			'as' => 'oauth.password.post.reset',
			'uses' => 'PasswordController@postReset'
		]);
		Route::post('oauth/password/change', [
			'as' => 'oauth.password.post.change',
			'middleware' => 'oauth',
			'uses' => 'PasswordController@postChangePassword'
		]);
	});
});

/*
|--------------------------------------------------------------------------
| Need access_token - grant_type
|--------------------------------------------------------------------------
*/

Route::group([
	'prefix' => 'api/v1',
	'namespace' => 'Api\v1',
	'middleware' => 'oauth'], function(){
/*
|--------------------------------------------------------------------------
| Authenticate
|--------------------------------------------------------------------------
*/
	Route::post('oauth/logout', [
		'as' => 'oauth.logout',
		'uses' => 'OAuthController@logout']);

/*
|--------------------------------------------------------------------------
| Users
|--------------------------------------------------------------------------
*/
	Route::post('users/profile/edit', 'UserController@edit');
	Route::post('users/profile/{id}/show', 'UserController@show');
	Route::post('users/profile/update', 'UserController@update');

/*
|--------------------------------------------------------------------------
| Friends
|--------------------------------------------------------------------------
*/
	Route::post('friends/{id}/delete', 'FriendController@delete');

/*
|--------------------------------------------------------------------------
| Posts
|--------------------------------------------------------------------------
*/
	Route::post('posts/list', [
		'as' => 'api.posts.list',
		'uses' => 'PostController@index'
	]);
	Route::post('posts/{id}/show', [
		'as' => 'api.posts.show',
		'uses' => 'PostController@show'
	]);
	Route::post('posts/{id}/like', [
		'as' => 'api.posts.like',
		'uses' => 'PostController@like'
	]);
});

/*
|--------------------------------------------------------------------------
| API table document
|--------------------------------------------------------------------------
*/
Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace' => 'Api\v1'], function(){
		Route::get('tables/users', 'TableController@users');
		Route::get('tables/friends', 'TableController@friends');
		Route::get('tables/posts', 'TableController@posts');
		Route::get('tables/likes', 'TableController@likes');
		Route::get('tables/comments', 'TableController@comments');
		Route::get('tables/venues', 'TableController@venues');
		Route::get('tables/notifications', 'TableController@notifications');
		Route::get('tables/request-zpots', 'TableController@requestzpots');
	});
});