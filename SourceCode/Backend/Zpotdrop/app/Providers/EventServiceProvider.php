<?php

namespace App\Providers;

use Illuminate\Contracts\Events\Dispatcher as DispatcherContract;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    /**
     * The event listener mappings for the application.
     *
     * @var array
     */
    protected $listen = [
        'App\Events\UserRegisterEvent' => [
            'App\Listeners\UserRegisterListener',
        ],
        'App\Events\UserFollowEvent' => [
            'App\Listeners\UserFollowPushListener',
            'App\Listeners\UserFollowUpdateStatusListener'
        ],
        'App\Events\SocialNetworkLoginEvent' => [
            'App\Listeners\SocialFriendSignUpNotificationLister'
        ],
        'App\Events\PostCommentEvent' => [
            'App\Listeners\PostCommentCountUpdateListener',
            'App\Listeners\PostCommentNotifyListener'
        ],
        'App\Events\PostLikeEvent' => [
            'App\Listeners\PostLikeCountUpdateListener',
            'App\Listeners\PostLikeNotifyListener'
        ],
        'App\Events\PostComingEvent' => [
            'App\Listeners\PostComingCountUpdateListener',
            'App\Listeners\PostComingNotifyListener'
        ],
    ];

    /**
     * Register any other events for your application.
     *
     * @param  \Illuminate\Contracts\Events\Dispatcher  $events
     * @return void
     */
    public function boot(DispatcherContract $events)
    {
        parent::boot($events);

        //
    }
}
