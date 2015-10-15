<?php

namespace App\Listeners;

use App\Acme\Models\Friend;
use App\Acme\Models\User;
use App\Events\UserFollowEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class UserFollowUpdateStatusListener  implements  ShouldQueue
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
     * @param  UserFollowEvent  $event
     * @return void
     */
    public function handle(UserFollowEvent $event)
    {
        \DB::transaction(function() use ($event) {
            if ($event->followType == Friend::FRIEND_FOLLOW) {
                User::where('id', $event->user->id)->increment('following_count', 1);
                User::where('id', $event->friend->id)->increment('follower_count', 1);

                $relation = Friend::where('user_id', $event->friend->id)
                    ->where('friend_id', $event->user->id)
                    ->where('is_friend', '>', Friend::FRIEND_REQUEST)->first();

                if ($relation) {
                    Friend::where('user_id', $event->friend->id)
                        ->where('friend_id', $event->user->id)
                        ->update(['is_friend' => Friend::FRIEND_YES]);

                    Friend::where('user_id', $event->user->id)
                        ->where('friend_id', $event->friend->id)
                        ->update(['is_friend' => Friend::FRIEND_YES]);
                }
            }

        });

    }
}
