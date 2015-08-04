<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateNotificationsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
	    if (Schema::hasTable('notifications'))
	    {
		    Schema::drop('notifications');
	    }
        Schema::create('notifications', function (Blueprint $table) {
	        $table->increments('id');
	        $table->unsignedInteger('user_id');
	        $table->unsignedInteger('friend_id');
	        $table->string('message')->default('');
	        $table->unsignedInteger('post_id');
	        $table->tinyInteger('action_type')->default(0);//0:coming, 1: comment, 2: like, 3: follow
	        $table->boolean('is_read')->default(0);//0: read 1: unread
            $table->timestamps();
        });

	    Schema::table('notifications', function($table)
	    {
		    $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
		    $table->foreign('friend_id')->references('id')->on('users');
		    $table->foreign('post_id')->references('id')->on('posts')->onDelete('cascade');
	    });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('notifications');
    }
}
