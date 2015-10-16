<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableUserSocial extends Migration
{
    private $table = 'user_social';
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->table, function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('user_id')->index();
            $table->string('uid', 50);
            $table->string('provider', 50);
            $table->string('email', 32);
            $table->string('username', 32)->nullable();
            $table->string('first_name', 32)->nullable();
            $table->string('last_name', 32)->nullable();
            $table->unsignedTinyInteger('gender')->nullable();
            $table->string('access_token', 512);
            $table->timestamps();

        });

        Schema::table($this->table, function(Blueprint $table) {
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
        Schema::drop($this->table);
    }
}
