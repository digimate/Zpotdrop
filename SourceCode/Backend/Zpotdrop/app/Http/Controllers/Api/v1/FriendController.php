<?php

namespace App\Http\Controllers\Api\v1;

use App\Models\Friend;
use App\Models\User;

class FriendController extends ApiController
{
    public function index()
    {
	    $friend  = Friend::with(['user', 'friend'])->get();
	    dd($friend->toArray());
    }

	public function delete($id){
		User::destroy($id);
	}
}
