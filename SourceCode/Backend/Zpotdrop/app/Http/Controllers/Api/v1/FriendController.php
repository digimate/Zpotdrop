<?php

namespace App\Http\Controllers\Api\v1;

use App\Acme\Models\Friend;
use App\Acme\Models\User;

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
