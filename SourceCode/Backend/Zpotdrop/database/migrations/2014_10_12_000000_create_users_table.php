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
	        $table->string('avatar', 255)->nullable();
	        $table->string('first_name', 50);
	        $table->string('last_name', 50)->nullable();
	        $table->string('phone_number', 20);
	        $table->string('home_town');
	        $table->date('birthday')->nullable();
	        $table->boolean('is_private')->default(false);
	        $table->boolean('is_enable_all_zpot')->default(false);
	        $table->float('lat')->nullable();
	        $table->float('long')->nullable();
	        $table->tinyInteger('status')->default(1); //active
	        $table->string('device_id', 100)->nullable();
	        $table->string('device_name', 255)->nullable();
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
