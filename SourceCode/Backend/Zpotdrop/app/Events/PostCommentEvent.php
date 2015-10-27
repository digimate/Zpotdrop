<?php

namespace App\Events;

use App\Acme\Models\Comment;
use App\Acme\Models\Post;
use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class PostCommentEvent extends Event
{
    use SerializesModels;

    public $userId;
    public $post;
    public $comment;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($userId, Post $post, Comment $comment)
    {
        $this->userId = $userId;
        $this->post = $post;
        $this->comment = $comment;
    }

    /**
     * Get the channels the event should be broadcast on.
     *
     * @return array
     */
    public function broadcastOn()
    {
        return [];
    }
}
