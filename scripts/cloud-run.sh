#!/bin/bash

#########################################################################################################
### The below code is for propogating out the DB schema + data from .sql file should the need arise
#########################################################################################################
# declare sql_file

# # Saved DB credentials
# echo *:*:*:$DB_USER:$DB_PASSWORD >~/.pgpass
# chmod 600 ~/.pgpass

# cd /var/www/db

# sql_file=$(find . -name "*.sql" -printf "%t %p\n" | sort -n | rev | cut -d' ' -f 1 | rev | tail -n1)

# if [[ "$sql_file" ]]; then
#     echo "Database dump found: ${sql_file}"

#     while ! pg_isready -h $DB_SERVER; do
#         echo "Waiting for PostreSQL server"
#         sleep 1
#     done

#     #echo "Importing database"
#     #echo "create database skyviewer;" > createDB.sql
#     #cat createDB.sql | psql -h $DB_SERVER -d $DB_SERVER -U $DB_USER
#     #cat "$sql_file" | psql -h $DB_SERVER -d skyviewer -U $DB_USER
    
#     echo "Removing SQL dump file now that DB has been restored."
#     rm $sql_file
#     echo "Removed."

# fi
# echo "Done importing DB!"
#########################################################################################################

 cd /app/craftcms

echo 'Installing composer dependencies.'
composer install

dependencies=$(cat composer.json |
    jq '.require' |
    jq --compact-output 'keys' |
    tr -d '[]"' | tr ',' '\n')

for package in ${dependencies}; do

    echo $package

    vendor=$(awk -F '[\/:]+' '{print $1}' <<<$package)
    packageName=$(awk -F '[\/:]+' '{print $2}' <<<$package)
    isCraftPlugin=$(cat vendor/$vendor/$packageName/composer.json | jq '.type == "craft-plugin"')

    if [ "$isCraftPlugin" = true ]; then
        handle=$(cat vendor/$vendor/$packageName/composer.json | jq -r '.extra.handle')
        ./craft install/plugin $handle
    fi
done

echo "Ensuring storage and web(project) directories are writable"
cd /app/craftcms
chmod -R 755 ./storage
chmod -R 755 ./web

echo '✅  All dependencies successfully installed.'

echo 'Applying project config file changes.'
./craft project-config/apply
echo '✅  All project config file changes applied.'

cd /app/craftcms/