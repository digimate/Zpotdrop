<?php

namespace App\Listeners;

use App\Acme\Models\Like;
use App\Acme\Models\Post;
use App\Events\LikePostEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class PostLikeCountUpdateListener implements ShouldQueue
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  LikePostEvent  $event
     * @return void
     */
    public function handle(LikePostEvent $event)
    {
        $count = $event->actionType == Like::LIKE ? 1 : -1;
        Post::increment('likes_count', $count);
    }
}
