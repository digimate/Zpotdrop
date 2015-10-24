<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLocationsTable extends Migration
{
    protected $table = 'locations';
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->table, function(Blueprint $table) {
            $table->increments('id');
            $table->string('name', 255);
            $table->string('address', 255);
            $table->string('lat', 20);
            $table->string('long', 20);
            $table->unsignedInteger('user_id');
            $table->softDeletes();
            $table->timestamps();

        });

        Schema::table($this->table, function(Blueprint $table) {

        });

        DB::statement("ALTER TABLE {$this->table} ADD FULLTEXT search(name, address)");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists($this->table);
    }
}
