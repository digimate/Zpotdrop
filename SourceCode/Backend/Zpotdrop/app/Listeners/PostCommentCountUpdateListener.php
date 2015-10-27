<?php

namespace App\Listeners;

use App\Acme\Models\Post;
use App\Events\CommentPostEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class PostCommentCountUpdateListener implements ShouldQueue
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
     * @param  CommentPostEvent  $event
     * @return void
     */
    public function handle(CommentPostEvent $event)
    {
        Post::increment('comments_count', 1);
    }
}
