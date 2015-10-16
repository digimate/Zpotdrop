<?php

namespace App\Listeners;

use App\Events\SocialNetworkLoginEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class SocialFriendSignUpNotificationLister implements  ShouldQueue
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
     * @param  SocialNetworkLoginEvent  $event
     * @return void
     */
    public function handle(SocialNetworkLoginEvent $event)
    {
        //
    }
}
