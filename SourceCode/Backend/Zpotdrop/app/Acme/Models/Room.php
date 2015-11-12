<?php

namespace App\Acme\Models;

class Room extends BaseModel
{
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'rooms';


    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'member_ids' => 'array',
    ];

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = [
		'room_id',
		'user_id',
		'name',
        'member_ids'
	];

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['id'];

    /**
     * get room chat
     * @param $userId
     * @param $page
     * @param $limit
     * @return \Illuminate\Contracts\Pagination\LengthAwarePaginator
     */
    public static function getRooms($userId, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);

        return Room::where('member_ids', 'like', '%"id":'.$userId.'%')
                    ->orderBy('updated_at', 'desc')->orderBy('created_at', 'desc')
                    ->paginate($limit, ['*'], 'page', $page);
    }

    /**
     * get room by id
     * @param $roomId
     * @return mixed
     */
    public static function findRoomById($roomId) {
        return Room::where('room_id', $roomId)->first();
    }
}