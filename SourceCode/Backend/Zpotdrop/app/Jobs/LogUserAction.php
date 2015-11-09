<?php

namespace App\Jobs;

use App\Acme\Models\UserAction;
use App\Jobs\Job;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class LogUserAction extends Job implements SelfHandling, ShouldQueue
{
    protected $userId;
    protected $action;


    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($userId, $action)
    {
        $this->userId = $userId;
        $this->action = $action;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        UserAction::create([
            'user_id' => $this->userId,
            'name' => UserAction::getActionName($this->action),
            'type' => $this->action
        ]);
    }
}
