<?php

namespace App\Jobs;

use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class TagUserNotify extends Job implements SelfHandling, ShouldQueue
{
    protected $tags;
    protected $userId;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($tags, $userId)
    {
        $this->tags = $tags;
        $this->userId = $userId;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        if (is_array($this->tags)) {
            $message = trans('notification.tag');
            $user = User::where('id', $this->userId)->select('id', 'first_name', 'last_name')->first();
            if (!$user) {
                \Log::error("TagUserNotify:user:not_found:userId={$this->userId}");
                return;
            }

            foreach ($this->tags as $friend) {
                try {
                    $notifyMessage = str_replace(['{username}'], [$user->username()], $message);
                    $notification = Notification::create([
                        'user_id' => $user->id,
                        'friend_id' => $friend['id'],
                        'message' => $notifyMessage,
                        'action_type' => Notification::ACTION_TYPE_TAG_USER,
                        'is_read' => Notification::IS_UNREAD
                    ]);

                    LZPushNotification::push($friend['device_type'], $friend['device_id'], [], $notification);
                }catch (\Exception $ex) {
                    \Log::error($ex->getMessage(), $ex->getTrace());
                }
            }
        }
    }
}
