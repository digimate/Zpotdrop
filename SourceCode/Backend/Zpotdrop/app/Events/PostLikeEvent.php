<?php

namespace App\Events;

use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class PostLikeEvent extends Event
{
    use SerializesModels;

    public $userId;
    public $postId;
    public $actionType;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($userId, $postId, $actionType)
    {
        $this->userId = $userId;
        $this->postId = $postId;
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
