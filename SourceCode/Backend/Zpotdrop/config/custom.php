<?php

return [

    'register_code_expire' => 2, // 2 days
    'upload_dir' => 'uploads',
    'cache' => [
        'enable' => true,
        'short_time' => 1, // 1 minute
        'medium_time' => 2,
        'long_time'  => 5,
    ],
    'pagination' => [
        'limit_min' => 1,
        'limit_max'  => 500,
    ],
    'geo' => [
        'distance' => 1, // 1km
    ]
];
