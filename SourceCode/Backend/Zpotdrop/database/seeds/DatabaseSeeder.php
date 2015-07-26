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
	    /*Truncate table*/
	    //DB::table('friends')->truncate();
	    //DB::table('users')->truncate();

	    /*user table*/
	    factory('App\Models\User', 10)->create();

	    /*friend table*/
	    factory('App\Models\Friend', 10)->create();

	    /*post table*/
	    factory('App\Models\Post', 10)->create();

	    /*comments*/
	    factory('App\Models\Comment', 100)->create();

	    /*likes*/
	    factory('App\Models\Like', 100)->create();
        Model::reguard();
    }
}
