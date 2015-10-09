<?php

namespace App\Jobs;

use App\Acme\Models\User;
use App\Acme\Models\UserMailVerify;
use App\Acme\Utils\Hash;
use App\Acme\Utils\Time;
use Illuminate\Mail\Mailer;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Bus\SelfHandling;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendRegisterConfirmEmail extends Job implements SelfHandling, ShouldQueue
{
    use InteractsWithQueue, SerializesModels;

    protected $user;
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(User $user)
    {
        $this->user = $user;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle(Mailer $mailer)
    {
        \Log::info('Create Code', $this->user->toArray());
        $code = UserMailVerify::where('user_id', $this->user->id)
                                ->where('expired_at', '>=', Time::getDateTime()->format('Y-m-d H:i:s'))->first();
        if (!$code) {
            $code = UserMailVerify::create([
                'user_id' => $this->user->id,
                'code'    => Hash::hexId(),
                'expired_at' => Time::getEndNextNDay(config('custom.register_code_expire'))
            ]);
        }
        if ($code) {
            \Log::info('SEND MAIL');
            $user = $this->user;
            $mailer->send('emails.register', ['user' => $this->user, 'code' => $code], function($message) use ($user) {
                $message->from(config('mail.from.address'), config('mail.from.name'));
                $message->to($user->email, $user->first_name . ' ' . $user->last_name);
                $message->subject(trans('mail.register_subject'));
            });
        }
    }
}
