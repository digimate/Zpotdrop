<?php

namespace App\Events;

use App\Acme\Models\User;
use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class UserFollowEvent extends Event
{
    use SerializesModels;

    public $user;
    public $friend;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct(User $user, User $friend)
    {
        $this->user = $user;
        $this->friend = $friend;
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
