<?php

namespace App\Jobs;

use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Acme\Transformers\UserTransformer;
use App\Jobs\Job;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class ZpotAcceptRequestNotify extends Job implements SelfHandling, ShouldQueue
{
    protected $notification;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(Notification $notification)
    {
        $this->notification = $notification;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $this->notification->is_read = Notification::IS_READ;
        $this->notification->save();

        $user = User::find($this->notification->user_id);
        $friend = User::find($this->notification->friend_id);

        if (!$user || !$friend) {
            return;
        }

        $transformer = new UserTransformer();
        $customData['friend_info'] = $transformer->transform($friend);
        $this->notification->action_type = Notification::ACTION_TYPE_ZPOT_ACCEPT;
        LZPushNotification::push($user->device_type, $user->device_id, $customData, $this->notification);
    }
}
