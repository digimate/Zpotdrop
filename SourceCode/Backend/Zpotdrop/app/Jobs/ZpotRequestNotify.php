<?php

namespace App\Jobs;

use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Jobs\Job;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class ZpotRequestNotify extends Job implements SelfHandling, ShouldQueue
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
        $friend = User::find($this->notification->friend_id);
        if (!$friend) {
            return;
        }

        LZPushNotification::push($friend->device_type, $friend->device_id, [], $this->notification);
    }
}
