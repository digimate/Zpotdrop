<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLikesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('likes', function(Blueprint $table){
	        $table->integer('user_id')->unsigned();
	        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
	        $table->integer('post_id')->unsigned();
	        $table->foreign('post_id')->references('id')->on('users')->onDelete('cascade');
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
        Schema::drop('likes');
    }
}
