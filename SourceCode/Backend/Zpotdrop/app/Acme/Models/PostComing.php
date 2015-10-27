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


class PostComing extends BaseModel
{
    const COMING = 1;
    const UNCOMING = -1;
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'post_cmins';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'user_id',
		'post_id',
        'status'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['updated_at', 'deleted_at'];

	/*Relations*/
	public function user(){
		return $this->belongsTo('App\Acme\Models\User', 'user_id');
	}

	public function post(){
		return $this->belongsTo('App\Acme\Models\Post', 'post_id');
	}


    /**
     * @param $postId
     * @param $page
     * @param $limit
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public static function getComingUsersOfPost($postId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);


        return PostComing::with(['user' => function($query) {
            $query->addSelect(['id', 'avatar', 'first_name', 'last_name']);
            $query->orderBy('follower_count', 'desc');
            $query->orderBy('first_name', 'asc');
            $query->orderBy('id', 'asc');
        }])
            ->where('post_id', $postId)
            ->paginate($limit, ['created_at', 'user_id'], 'page', $page);
    }
}