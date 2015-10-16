<?php

namespace App\Events;

use App\Acme\Models\User;
use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class SocialNetworkLoginEvent extends Event
{
    use SerializesModels;

    public $user;
    public $uid;
    public $accessToken;
    public $provider;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct(User $user, $uid, $accessToken, $provider)
    {
        $this->user = $user;
        $this->uid = $uid;
        $this->accessToken = $accessToken;
        $this->provider = $provider;
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
