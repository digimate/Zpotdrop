<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Model::unguard();

        // $this->call(UserTableSeeder::class);
		DB::table('oauth_clients')->insert([
			'id'        => 's6BhdRkqt3',
			'secret'    => '7Fjfp0ZBr1KtDRbnfVdmIw',
			'name'      => 'mobile'
		]);

	    /*user table*/
	    factory('App\Acme\Models\User', 10)->create();

	    /*friend table*/
	    factory('App\Acme\Models\Friend', 10)->create();

	    /*venue table*/
	    factory('App\Acme\Models\Venue', 10)->create();

	    /*post table*/
	    factory('App\Acme\Models\Post', 10)->create();

	    /*comments*/
	    factory('App\Acme\Models\Comment', 100)->create();

	    /*likes*/
	    factory('App\Acme\Models\Like', 100)->create();
        Model::reguard();
    }
}
