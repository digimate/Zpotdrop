<?php

namespace App\Jobs;

use App\Acme\Models\Notification;
use App\Acme\Models\User;
use App\Acme\Notifications\LZPushNotification;
use App\Jobs\Job;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class ScanNotify extends Job implements SelfHandling, ShouldQueue
{
    protected $userId;
    protected $arrUsers;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($userId, $users)
    {
        $this->userId = $userId;
        $this->arrUsers = $users;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $user = User::where('id', $this->userId)->select('id', 'last_name', 'first_name')->first();
        $message = trans('notification.zpot');
        $username = "{$user['first_name']} {$user['last_name']}";


        foreach ($this->arrUsers as $friend) {
            $notifyMessage = str_replace(['{username}'], [$username], $message);
            try {
                $params = json_encode([
                    '{username}' => $username
                ]);
                $notification = Notification::create([
                    'user_id' => $user->id,
                    'friend_id' => $friend['id'],
                    'params' => $params,
                    'message' => $notifyMessage,
                    'action_type' => Notification::ACTION_TYPE_ZPOT_REQUEST,
                    'is_read' => Notification::IS_UNREAD
                ]);

                LZPushNotification::push($friend['device_type'], $friend['device_id'], [], $notification);
            }catch (\Exception $ex) {
                \Log::error($ex->getMessage(), $ex->getTrace());
            }
        }
    }
}
