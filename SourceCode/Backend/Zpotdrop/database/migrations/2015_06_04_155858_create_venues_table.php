<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateVenuesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
	    if (Schema::hasTable('venues'))
	    {
		    Schema::drop('venues');
	    }
        Schema::create('venues', function (Blueprint $table) {
            $table->increments('id');
	        $table->string('name');
	        $table->unsignedInteger('user_id');
	        $table->double('lat', 15, 6)->default(0);
	        $table->double('long', 15, 6)->default(0);
	        $table->softDeletes();
            $table->timestamps();
        });

	    Schema::table('venues', function($table)
	    {
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
        Schema::drop('venues');
    }
}
