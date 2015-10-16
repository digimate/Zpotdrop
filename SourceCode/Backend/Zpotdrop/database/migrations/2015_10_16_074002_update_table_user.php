<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateTableUser extends Migration
{
    private $table='users';
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table($this->table, function(Blueprint $table){
            $table->string('first_name', 50)->nullable()->change();
            $table->string('last_name', 50)->nullable()->change();
            $table->date('birthday')->nullable()->change();
            $table->string('phone_number', 20)->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
