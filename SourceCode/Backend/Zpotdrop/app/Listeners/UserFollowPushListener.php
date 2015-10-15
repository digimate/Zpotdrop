<?php

namespace App\Listeners;

use App\Acme\Models\Friend;
use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Events\UserFollowEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class UserFollowPushListener implements  ShouldQueue
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
            $message = ($event->followType == Friend::FRIEND_FOLLOW) ? trans('notification.follow') : trans('notification.follow_request');
            $message = str_replace(['{username}'], [$event->user->username()], $message);

            $notification = Notification::create([
               'user_id' => $event->user->id,
                'friend_id' => $event->friend->id,
                'message' => $message,
                'action_type' => ($event->followType == Friend::FRIEND_FOLLOW) ? Notification::ACTION_TYPE_FOLLOWING : Notification::ACTION_TYPE_FOLLOW_REQUEST,
                'is_read' => Notification::IS_UNREAD
            ]);

            if ($notification) {
                try {
                    LZPushNotification::push($event->friend->device_type, $event->friend->device_id, $event->followType, $notification);
                } catch( \Exception $ex) {
                    \Log::error($ex->getMessage(), $ex->getTrace());
                }
            }
        });
    }
}
