<?php

namespace App\Listeners;

use App\Acme\Models\PostComing;
use App\Events\PostComingEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use App\Acme\Models\User;
use App\Acme\Models\Notification;
use App\Acme\Notifications\LZPushNotification;

class PostComingNotifyListener implements ShouldQueue
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
     * @param  PostComingEvent  $event
     * @return void
     */
    public function handle(PostComingEvent $event)
    {
        if ($event->actionType == PostComing::COMING) {
            \DB::transaction(function() use ($event) {
                $user = User::find($event->userId);
                $post = $event->post;
                $notifyUser = User::find($post->user_id);
                if (!$user) {
                    return;
                }
                $message = trans('notification.coming');
                $message = str_replace(['{username}'], [$user->username()], $message);

                $notification = Notification::create([
                    'user_id' => $user->id,
                    'friend_id' => $post->user_id,
                    'post_id' => $post->id,
                    'message' => $message,
                    'action_type' => Notification::ACTION_TYPE_COMING,
                    'is_read' => Notification::IS_UNREAD
                ]);

                if ($notification) {
                    try {
                        $customData = [
                            'push_type' => $notification->action_type
                        ];
                        LZPushNotification::push($notifyUser->device_type, $notifyUser->device_id, $customData, $notification);
                    } catch( \Exception $ex) {
                        \Log::error($ex->getMessage(), $ex->getTrace());
                    }
                }
            });
        }
    }
}
