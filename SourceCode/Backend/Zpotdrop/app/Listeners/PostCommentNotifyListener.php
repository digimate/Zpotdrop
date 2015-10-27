<?php

namespace App\Listeners;

use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Events\CommentPostEvent;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;

class PostCommentNotifyListener implements ShouldQueue
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
     * @param  CommentPostEvent  $event
     * @return void
     */
    public function handle(CommentPostEvent $event)
    {
        \DB::transaction(function() use ($event) {
            $user = User::find($event->userId);
            $notifyUser = User::find($event->post->user_id);
            if (!$user) {
                return;
            }
            $message = trans('notification.comment');
            $message = str_replace(['{username}', '{comment_content}'], [$user->username(), $event->comment->message], $message);

            $notification = Notification::create([
                'user_id' => $user->id,
                'friend_id' => $event->post->user_id,
                'post_id' => $event->post->id,
                'message' => $message,
                'action_type' => Notification::ACTION_TYPE_COMMENT,
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
