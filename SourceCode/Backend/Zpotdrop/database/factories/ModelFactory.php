<?php

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| Here you may define all of your model factories. Model factories give
| you a convenient way to create models for testing and seeding your
| database. Just tell the factory how a default model should look.
|
*/

$factory->define(App\Models\User::class, function (Faker\Generator $faker) {
    return [
        'first_name'        => $faker->firstName,
	    'last_name'         => $faker->lastName,
        'email'             => $faker->email,
	    'avatar'            => $faker->imageUrl(120, 120, 'people', true),
        'password'          => bcrypt('123456'),
	    'phone_number'      => $faker->phoneNumber,
	    'home_town'         => $faker->country,
	    'birthday'          => $faker->dateTimeThisYear,
		'lat'               => $faker->latitude,
	    'long'              => $faker->longitude,
	    'device_id'         => $faker->md5,
	    'device_name'       => array_rand(['iPhone5s', 'iPhone6Plus', 'Nexus7', 'OppoFind5']),
	    'device_type'       => rand(0, 2),
        'remember_token'    => str_random(10),
    ];
});

$factory->define(App\Models\Friend::class, function(Faker\Generator $faker){
	return [
		'user_id'           => rand(1, 4),
		'friend_id'         => rand(5, 10),
	];
});

$factory->define(App\Models\Post::class, function (Faker\Generator $faker) {
	return [
		'status'            => $faker->sentence,
		'venue_name'        => $faker->address,
		'venue_lat'         => $faker->latitude,
		'venue_long'        => $faker->longitude,
		'user_id'           => rand(1, 10),
	];
});

$factory->define(App\Models\Comment::class, function(Faker\Generator $faker){
	return [
		'user_id'          => rand(1, 10),
		'post_id'          => rand(1, 10),
		'message'          => $faker->sentence
	];
});

$factory->define(App\Models\Like::class, function(Faker\Generator $faker){
	return [
		'user_id'          => rand(1, 10),
		'post_id'          => rand(1, 10),
	];
});