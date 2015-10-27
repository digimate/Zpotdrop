<?php

namespace App\Jobs;

use App\Acme\Models\User;
use App\Jobs\Job;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class UpdateUserDropWhenCreatePost extends Job implements SelfHandling, ShouldQueue
{
    use InteractsWithQueue, SerializesModels;

    protected $userId;
    protected $lat;
    protected $long;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($userId, $lat, $long)
    {
        $this->userId = $userId;
        $this->lat = $lat;
        $this->long = $long;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        User::where('id', $this->userId)->increment('drop_count', 1, ['lat' => $this->lat, 'long' => $this->long]);
    }
}
