<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
	    if (Schema::hasTable('posts'))
	    {
			Schema::drop('posts');
	    }
        Schema::create('posts', function (Blueprint $table) {
            $table->increments('id');
	        $table->string('status');
	        $table->unsignedInteger('venue_id');
	        $table->unsignedInteger('user_id');
	        $table->integer('likes_count')->default(0);
	        $table->integer('comments_count')->default(0);
	        $table->softDeletes();
	        $table->timestamps();
        });

	    Schema::table('posts', function($table)
	    {
		    $table->foreign('venue_id')->references('id')->on('venues')->onDelete('cascade');
		    $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
	    });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('posts');
    }
}
