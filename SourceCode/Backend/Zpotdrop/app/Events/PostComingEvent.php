<?php

namespace App\Events;

use App\Acme\Models\Post;
use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class PostComingEvent extends Event
{
    use SerializesModels;

    public $userId;
    public $post;
    public $actionType;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($userId, Post $post, $actionType)
    {
        $this->userId = $userId;
        $this->post = $post;
        $this->actionType = $actionType;
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
