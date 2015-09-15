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
	    if (Schema::hasTable('likes'))
	    {
		    Schema::drop('likes');
	    }
        Schema::create('likes', function(Blueprint $table){
	        $table->unsignedInteger('user_id');
	        $table->unsignedInteger('post_id');
	        $table->softDeletes();
	        $table->timestamps();
        });
	    
	    Schema::table('likes', function($table)
	    {
		    $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
		    $table->foreign('post_id')->references('id')->on('users')->onDelete('cascade');
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
