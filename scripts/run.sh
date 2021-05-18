#!/bin/bash

set -e

cd /var/www/html

if [ "$ACTION" == "install" ] 
then
    echo "Installing Craft CMS!"
    composer create-project craftcms/craft /var/www/html/craftcms
else
    echo "Skipping Craft CMS installation step."
fi

# Start php-fpm
exec "$@"