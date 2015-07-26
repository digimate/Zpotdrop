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

namespace App\Models;


class Like extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'likes';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'user_id',
		'post_id'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['user_id', 'post_id', 'deleted_at'];

	/**
	 * Finish processing on a successful save operation.
	 *
	 * @param  array $options
	 * @return void
	 */
	protected function finishSave(array $options)
	{
		/*get post and make like ++*/
		$post = new Post();
		$post->makeLike($this->getAttribute('post_id'));
	}

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Models\User', 'user_id');
	}

	public function post(){
		return $this->belongsTo('App\Models\Post', 'post_id');
	}
}