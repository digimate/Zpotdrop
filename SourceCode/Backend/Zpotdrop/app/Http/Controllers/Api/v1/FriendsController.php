<?php

namespace App\Http\Controllers\Api\v1;

use App\Models\Friend;

class FriendsController extends ApiController
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
	    $friend  = Friend::with(['user', 'friend'])->get();
	    dd($friend->toArray());
    }
}
