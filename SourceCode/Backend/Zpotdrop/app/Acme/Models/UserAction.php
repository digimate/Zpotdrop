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

class UserAction extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'user_actions';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = ['user_id', 'name', 'type'];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['name'];

    /*
     * define action_type => user action_type was defined at Notification model
     */

    public static function getActionName($actionType) {
        $action = '';
        switch($actionType) {
            case Notification::ACTION_TYPE_COMMENT:
                $action = 'Post';
                break;
            case Notification::ACTION_TYPE_ZPOT_REQUEST:
                $action = 'Scan/Zpot';
                break;
            case Notification::ACTION_TYPE_ZPOT_ALL:
                $action = 'All zpot';
                break;
        }
        return $action;
    }


	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id', 'id');
	}

}
