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
        Schema::create('posts', function (Blueprint $table) {
            $table->increments('id');
	        $table->string('status');
	        $table->string('venue_name');
	        $table->float('venue_lat')->default(0);
	        $table->float('venue_long')->default(0);
	        $table->integer('user_id')->unsigned();
	        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
	        $table->integer('likes_count')->default(0);
	        $table->integer('comments_count')->default(0);
	        $table->softDeletes();
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
        Schema::table('posts', function (Blueprint $table) {
            //
        });
    }
}
