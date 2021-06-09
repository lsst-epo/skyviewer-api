#!/bin/bash
declare sql_file

# Saved DB credentials
echo *:*:*:$DB_USER:$DB_PASSWORD >~/.pgpass
chmod 600 ~/.pgpass

cd /var/www/db

sql_file=$(find . -name "*.sql" -printf "%t %p\n" | sort -n | rev | cut -d' ' -f 1 | rev | tail -n1)

if [[ "$sql_file" ]]; then
    echo "Database dump found: ${sql_file}"

    while ! pg_isready -h $DB_SERVER; do
        h2 "Waiting for PostreSQL server"
        sleep 1
    done

    echo "Importing database"
    #comment out below line to prevent db from being recreated each: docker-compose up
    cat "$sql_file" | psql -h $DB_SERVER -d $DB_SERVER -U $DB_USER
    
    echo "Removing SQL dump file now that DB has been restored."
    rm $sql_file
    echo "Removed."


fi
echo "Done importing DB!"

# Start php-fpm
exec "$@"