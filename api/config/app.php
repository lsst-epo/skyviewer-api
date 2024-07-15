<?php
/**
 * Yii Application Config
 *
 * Edit this file at your own risk!
 *
 * The array returned by this file will get merged with
 * vendor/craftcms/cms/src/config/app.php and app.[web|console].php, when
 * Craft's bootstrap script is defining the configuration for the entire
 * application.
 *
 * You can define custom modules and system components, and even override the
 * built-in system components.
 *
 * If you want to modify the application config for *only* web requests or
 * *only* console requests, create an app.web.php or app.console.php file in
 * your config/ folder, alongside this one.
 */

use craft\helpers\App;

return [
    'id' => App::env('APP_ID') ?: 'CraftCMS',
    'modules' => [
        'my-module' => \modules\Module::class,
    ],
    'components' => [
        'redis' => [
            'class' => yii\redis\Connection::class,
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
        ],
        'cache' => static function() {
            $config = [
                'class' => yii\redis\Cache::class,
                'keyPrefix' => Craft::$app->id,
                'defaultDuration' => Craft::$app->config->general->cacheDuration,
            ];

            return Craft::createObject($config);
        },
    ],
    //'bootstrap' => ['my-module'],
];
