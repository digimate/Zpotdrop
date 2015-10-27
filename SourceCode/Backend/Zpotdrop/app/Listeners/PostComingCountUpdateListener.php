<?php

namespace App\Listeners;

use App\Acme\Models\Post;
use App\Acme\Models\PostComing;
use App\Events\PostComingEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class PostComingCountUpdateListener implements ShouldQueue
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
     * @param  PostComingEvent  $event
     * @return void
     */
    public function handle(PostComingEvent $event)
    {
        $count = $event->actionType == PostComing::COMING ? 1 : -1;
        Post::where('id', $event->post->id)->increment('cmin_count', $count);
    }
}
