<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AlterPostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign('posts_venue_id_foreign');
            $table->renameColumn('venue_id', 'location_id');
            $table->text('with_tags')->after('user_id');
            $table->string('lat', 20)->after('user_id');
            $table->string('long', 20)->after('user_id');
            $table->string('geo_point', 50)->nullable()->after('user_id');
            $table->unsignedInteger('cmin_count')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('colors', function (Blueprint $table) {
            //
        });
    }
}
