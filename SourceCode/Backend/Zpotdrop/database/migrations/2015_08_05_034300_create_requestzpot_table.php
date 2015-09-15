<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateRequestzpotTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('request_zpots', function (Blueprint $table) {
	        $table->unsignedInteger('user_id')->index();
	        $table->unsignedInteger('friend_id')->index();
            $table->timestamps();
        });

	    Schema::table('request_zpots', function($table)
	    {
	        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
		    $table->foreign('friend_id')->references('id')->on('users')->onDelete('cascade');
	    });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('request_zpots');
    }
}
