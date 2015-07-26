<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFriendsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('friends', function(Blueprint $table) {
            $table->integer('user_id')->unsigned()->index();
            $table->integer('friend_id')->unsigned()->index();
            $table->boolean('is_friend')->default(false); //1: friend, 0: follow/following
            $table->timestamps();
        });

	    Schema::table('friends', function(Blueprint $table){
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
        Schema::drop('friends');
    }
}