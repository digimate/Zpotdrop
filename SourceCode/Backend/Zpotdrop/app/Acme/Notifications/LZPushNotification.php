<?php
/*
|--------------------------------------------------------------------------
| LZNotification.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 8/3/15 - 10:59 PM
*/

namespace App\Acme\Notifications;

use PushNotification;

class LZPushNotification
{
	public function test()
	{
		$devices = PushNotification::DeviceCollection(array(
			PushNotification::Device('token', array('badge' => 5)),
			PushNotification::Device('token1', array('badge' => 1)),
			PushNotification::Device('token2')
		));
		$message = PushNotification::Message('Message Text',array(
			'badge' => 1,
			'sound' => 'example.aiff',

			'actionLocKey' => 'Action button title!',
			'locKey' => 'localized key',
			'locArgs' => array(
				'localized args',
				'localized args',
			),
			'launchImage' => 'image.jpg',

			'custom' => array('custom data' => array(
				'we' => 'want', 'send to app'
			))
		));

		$collection = PushNotification::app('appNameIOS')
			->to($devices)
			->send($message);

// get response for each device push
		foreach ($collection->pushManager as $push) {
			$response = $push->getAdapter()->getResponse();
		}

// access to adapter for advanced settings
		$push = PushNotification::app('appNameAndroid');
		$push->adapter->setAdapterParameters(['sslverifypeer' => false]);
	}
}