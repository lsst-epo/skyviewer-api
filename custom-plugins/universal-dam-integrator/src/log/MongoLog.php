<?php

namespace rosas\dam\mongo;

use \yii\BaseYii;

class MongoLog extends BaseYii {

    public function __construct() {
        parent::__construct();
    }

    public function init()
    {
        parent::init();
    }

    /**
     * @return Logger message logger
     */
    public static function getLogger()
    {
        echo "\n\nRosas!!!!!!\n\n";
        if (self::$_logger !== null) {
            return self::$_logger;
        }

        return self::$_logger = static::createObject('yii\log\Logger');
    }

} 