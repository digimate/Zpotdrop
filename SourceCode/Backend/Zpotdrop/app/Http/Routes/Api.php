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
| Don't need Oauth2
|--------------------------------------------------------------------------
*/

Route::group(['prefix' => 'api/v1'], function(){
	Route::group(['namespace'=>'Api\v1'], function(){
		Route::post('oauth/register', [
			'as' => 'oauth.register',
			'uses' => 'OAuthController@register'
		]);
        Route::post('oauth/social', [
            'as' => 'oauth.social',
            'uses' => 'OAuthController@social'
        ]);
		Route::post('oauth/login', [
            'as' => 'oauth.login',
            'uses' => 'OAuthController@login'
        ]);
/*
|--------------------------------------------------------------------------
| Password
|--------------------------------------------------------------------------
*/
		Route::post('oauth/password/remind', 'PasswordController@remindPassword');

        Route::post('oauth/password/change', [
            'as' => 'oauth.password.post.change',
            'middleware' => 'oauth',
            'uses' => 'PasswordController@postChangePassword'
        ]);
        /* chuyen sang routes.php
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
		]);*/
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
	Route::get('users/profile/{id}/show', 'UserController@show');
	Route::post('users/profile/update', 'UserController@update');


    /*
|--------------------------------------------------------------------------
| Follow
|--------------------------------------------------------------------------
*/
    Route::post('/users/friends/{friend_id}/follow', 'FollowController@follow');
    Route::post('/users/friends/{friend_id}/follow/accept', 'FollowController@accept');
    Route::get('/users/friends/{friend_id}/check', 'FollowController@check');
    Route::get('/users/friends/followers', 'FollowController@followers');
    Route::get('/users/friends/followings', 'FollowController@followings');
    Route::get('/users/friends', 'FollowController@friends');


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
    Route::post('posts/create', [
        'as' => 'api.post.add',
        'uses' => 'PostController@add'
    ]);
	Route::get('posts/list', [
		'as' => 'api.posts.list',
		'uses' => 'PostController@index'
	]);
	Route::get('posts/{id}', [
		'as' => 'api.posts.detail',
		'uses' => 'PostController@detail'
	]);

    //likes
    Route::get('posts/{id}/like/check', [
        'as' => 'api.post.like.check',
        'uses' => 'PostController@isLike'
    ]);
    Route::get('posts/{id}/likes', [
        'as' => 'api.posts.likes',
        'uses' => 'PostController@likes'
    ]);
	Route::post('posts/{id}/like', [
		'as' => 'api.posts.like',
		'uses' => 'PostController@like'
	]);
    Route::post('posts/{id}/unlike', [
        'as' => 'api.posts.unlike',
        'uses' => 'PostController@unLike'
    ]);

    // comment
    Route::get('posts/{id}/comments', [
        'as' => 'api.posts.comments',
        'uses' => 'PostController@comments'
    ]);
    Route::post('posts/{id}/comment', [
        'as' => 'api.posts.comment',
        'uses' => 'PostController@comment'
    ]);

    // coming
    Route::get('posts/{id}/coming/check', [
    'as' => 'api.post.coming.check',
        'uses' => 'PostController@isComing'
    ]);
    Route::get('posts/{id}/comings', [
        'as' => 'api.posts.comings',
        'uses' => 'PostController@comings'
    ]);
    Route::post('posts/{id}/coming', [
        'as' => 'api.posts.coming',
        'uses' => 'PostController@coming'
    ]);
    /*
|--------------------------------------------------------------------------
| Location
|--------------------------------------------------------------------------
*/
    //Route::post('/users/friends/{friend_id}/follow', 'FollowController@follow');
    Route::post('/geo/location', [
        'as' => 'api.location.add',
        'uses' => 'LocationController@add'
    ]);
    Route::get('/geo/locations', [
        'as' => 'api.location.search',
        'uses' => 'LocationController@locations'
    ]);

/*
|--------------------------------------------------------------------------
| Zpot
|--------------------------------------------------------------------------
*/

    Route::post('/zpot/users/{id}/request', [
        'as' => 'api.zpot.request',
        'uses' => 'ZpotController@request'
    ]);
    Route::post('/zpot/users/answer', [
        'as' => 'api.zpot.answer',
        'uses' => 'ZpotController@answer'
    ]);
    Route::post('/zpot/scan', [
        'as' => 'api.zpot.scan',
        'uses' => 'ZpotController@scan'
    ]);
    Route::get('/zpot/zpotall/check', [
        'as' => 'api.zpot.all.check',
        'uses' => 'ZpotController@zpotAllCheck'
    ]);

/*
|--------------------------------------------------------------------------
| Notification
|--------------------------------------------------------------------------
*/
    Route::get('/notifications/list', [
        'as' => 'api.notifications.list',
        'uses' => 'NotificationController@getNotifications'
    ]);
    Route::post('/notifications/{id}/read', [
        'as' => 'api.notifications.read',
        'uses' => 'NotificationController@markRead'
    ]);


/*
|--------------------------------------------------------------------------
| Chat
|--------------------------------------------------------------------------
*/

    Route::get('/chat/rooms', [
        'as' => 'api.chat.rooms',
        'uses' => 'ChatController@getRooms'
    ]);
    Route::post('/chat/room/create', [
        'as' => 'api.chat.room.create',
        'uses' => 'ChatController@createRoom'
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