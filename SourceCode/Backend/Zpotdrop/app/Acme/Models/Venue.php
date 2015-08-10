<?php
/*
|--------------------------------------------------------------------------
| Like.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 9:37 PM
*/

namespace App\Acme\Models;


/**
 * App\Models\Venue
 *
 * @SWG\Model (
 *    id="Venue",
 * 	@SWG\Property(name="name", type="string", required=true),
 * 	@SWG\Property(name="user_id", type="integer", required=true),
 * 	@SWG\Property(name="lat", type="float", required=true),
 * 	@SWG\Property(name="long", type="float", required=true),
 *  @SWG\Property(name="deleted_at", type="string",format="datetime"),
 *  @SWG\Property(name="created_at", type="string",format="datetime"),
 *  @SWG\Property(name="updated_at", type="string",format="datetime"),
 * )
 * @property integer $id 
 * @property string $name 
 * @property integer $user_id 
 * @property float $lat 
 * @property float $long 
 * @property string $deleted_at 
 * @property \Carbon\Carbon $created_at 
 * @property \Carbon\Carbon $updated_at 
 * @property-read \App\Acme\Models\User $user 
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereName($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereUserId($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereLat($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereLong($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereDeletedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereCreatedAt($value)
 * @method static \Illuminate\Database\Query\Builder|\App\Acme\Models\Venue whereUpdatedAt($value)
 */
class Venue extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'venues';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'name',
		'user_id',
		'lat',
		'long'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['user_id', 'deleted_at'];

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}
}