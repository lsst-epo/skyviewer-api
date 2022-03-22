<?php
/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 *
 * @see \craft\config\GeneralConfig
 */

use craft\helpers\App;

$isDev = App::env('ENVIRONMENT') === 'dev';
$isProd = App::env('ENVIRONMENT') === 'production';
$gcsBucketPathFormat = 'https://storage.googleapis.com/%s/';

return [
    '*' => [
        // Default Week Start Day (0 = Sunday, 1 = Monday...)
        'defaultWeekStartDay' => 1,

        // Whether generated URLs should omit "index.php"
        'omitScriptNameInUrls' => true,

        // Control Panel trigger word
        'cpTrigger' => 'admin',

        // The secure key Craft will use for hashing and encrypting data
        'securityKey' => App::env('SECURITY_KEY'),

        // Temp fix for login bug:
        //'requireUserAgentAndIpForSession' => false,

        // Whether to save the project config out to config/project.yaml
        // (see https://docs.craftcms.com/v3/project-config.html)
        'useProjectConfigFile' => true,

        'headlessMode' => true,

        'aliases' => [
            '@previewUrlFormat' => App::env('ALIAS_PREVIEW_URL_FORMAT'),
            '@webBaseUrl' => App::env('WEB_BASE_URL'),
            '@gcsBucketUrl' => sprintf(
                $gcsBucketPathFormat,
                App::env('GCS_ASSET_BUCKET')
            ),
            '@cantoAppId' => App::env('CANTO_APP_ID'),
            '@cantoSecretKey' => App::env('CANTO_SECRET_KEY'),
            '@cantoAuthEndpoint' => App::env('CANTO_AUTH_ENDPOINT'),
            '@cantoAssetEndpoint' => App::env('CANTO_ASSET_ENDPOINT'),
            '@cantoAssetBaseUrl' => App::env('CANTO_ASSET_BASEURL'),

        ],

        // Configured in nginx config for local dev, and needs to be configured in nginx
        // on staging / production, too. It's not easy to get Craft to serve CORS headers
        // for both GraphQL and non-Graphql requests (eg, the contact form), so we went
        // with this approach.
        'allowedGraphqlOrigins' => false
    ],

    // Dev environment settings
    'dev' => [
        // Dev Mode (see https://craftcms.com/guides/what-dev-mode-does)
        'devMode' => App::env('ENVIRONMENT') === 'dev',
    ],

    // Staging environment settings
    'staging' => [
        // Set this to `false` to prevent administrative changes from being made on staging
        'allowAdminChanges' => false,
    ],

    // Production environment settings
    'production' => [
        // Set this to `false` to prevent administrative changes from being made on production
        'allowAdminChanges' => false,
    ],
];
