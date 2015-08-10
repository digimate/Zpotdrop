<?php
/*
|--------------------------------------------------------------------------
| TestController.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 8/2/15 - 11:53 AM
*/

namespace App\Http\Controllers;
use LRedis;

class TestController extends Controller
{
	public function redis()
	{
		$redis = LRedis::connection();
		$redis->set('name', 'Phu');

		dd($redis->get('name'));
	}

	public function beanstalk()
	{
		\Queue::push(function($job){
			\Log::info('Queues are cool');
			$job->delete();
		});
	}
}