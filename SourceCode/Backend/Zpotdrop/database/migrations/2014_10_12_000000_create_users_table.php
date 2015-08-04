<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->increments('id');
            $table->string('email')->unique();
            $table->string('password', 60);
	        $table->string('avatar');
	        $table->string('first_name', 50);
	        $table->string('last_name', 50);
	        $table->string('hash', 10);
	        $table->date('birthday');
	        $table->tinyInteger('gender'); //0: male 1: female: 2: others
	        $table->string('phone_number', 20)->unique();
	        $table->string('home_town');
	        $table->boolean('is_private')->default(false);
	        $table->boolean('is_enable_all_zpot')->default(false);
	        $table->float('lat')->default(0);
	        $table->float('long')->default(0);
	        $table->tinyInteger('status')->default(1); //active
	        $table->string('device_id', 100)->default('');
	        $table->string('device_name');
	        $table->tinyInteger('device_type'); //0: ios 1: android 2: web
	        $table->rememberToken();
	        $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('users');
    }
}
