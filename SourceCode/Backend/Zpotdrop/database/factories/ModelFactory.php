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
	    'home_town'         => $faker->address,
	    'age'               => rand(20, 100),
		'lat'               => $faker->latitude,
	    'long'              => $faker->longitude,
        'remember_token'    => str_random(10),
    ];
});

$factory->define(App\Models\Friend::class, function(Faker\Generator $faker){
	return [
		'user_id'           => rand(1, 4),
		'friend_id'         => rand(5, 10),
	];
});