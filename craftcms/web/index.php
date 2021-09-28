<?php
/**
 * Craft web bootstrap file
 */

// Define path constants
define('CRAFT_BASE_PATH', dirname(__DIR__));
define('CRAFT_VENDOR_PATH', CRAFT_BASE_PATH . '/vendor');
define('SECRETS_DIR', '/var/secrets');

// Load Composer's autoloader
require_once CRAFT_VENDOR_PATH . '/autoload.php';

// Load dotenv?
if (class_exists('Dotenv\Dotenv') && file_exists(SECRETS_DIR . '/.env')) {
    Dotenv\Dotenv::create(SECRETS_DIR)->load();
}

// Define additional PHP constants
// (see https://craftcms.com/docs/3.x/config/#php-constants)
define('CRAFT_ENVIRONMENT', getenv('ENVIRONMENT') ?: 'production');
// ...

// Load and run Craft
/** @var craft\web\Application $app */
$app = require CRAFT_VENDOR_PATH . '/craftcms/cms/bootstrap/web.php';
$app->run();
