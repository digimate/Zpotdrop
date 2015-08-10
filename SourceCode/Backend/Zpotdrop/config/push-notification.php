<?php

return array(
	'deviceIOS'     => array(
		'environment' =>'development',
		'certificate' =>'/path/to/certificate.pem',
		'passPhrase'  =>'password',
		'service'     =>'apns'
	),
	'deviceAndroid' => array(
		'environment' =>'production',
		'apiKey'      =>'yourAPIKey',
		'service'     =>'gcm'
	)
);