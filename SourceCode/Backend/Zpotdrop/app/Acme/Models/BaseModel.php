<?php
/*
|--------------------------------------------------------------------------
| BaseModel.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 1:32 PM
*/

namespace App\Acme\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\BaseModel
 *
 */
class BaseModel extends Model
{
    public static function getMaxLimit() {
        return config('custom.pagination.limit_max');
    }

    public static function getMinLimit() {
        return config('custom.pagination.limit_min');
    }

    public static function setLimit($limit) {
        $maxLimit = self::getMaxLimit();
        if ($limit < 0 || $limit > $maxLimit) {
            $limit = $maxLimit;
        }
        return $limit;
    }

    public static function setPage($page) {
        if ($page < 0) {
            $page = 1;
        }
        return $page;
    }
}