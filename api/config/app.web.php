<?php

use craft\helpers\App;

return [
    'components' => [
        'session' => function() {
            // Get the default component config:
            $config = craft\helpers\App::sessionConfig();

            // Replace component class:
            $config['class'] = yii\redis\Session::class;

            // Define additional properties:
            $config['redis'] = [
                'hostname' => App::env('REDIS_HOSTNAME') ?: 'localhost',
                'port' => App::env('REDIS_PORT') ?: 6378,
                'password' => App::env('REDIS_PASSWORD') ?: null,
                'database' => App::env('REDIS_CRAFT_DB') ?: 0,
                'useSSL' => App::env('REDIS_USE_SSL'),
                'contextOptions' => [
                    'ssl' => [
                        'verify_peer' => false,
                        'verify_peer_name' => false,
                    ]
                ]
            ];

            // Return the initialized component:
            return Craft::createObject($config);
        }
    ],
];

?>