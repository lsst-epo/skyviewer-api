# Database Configuration

---

### To use a local db

1. To list the local databases for this project, first bring up the postgres container if it's not already up:

`docker-compose -f docker-compose-local-db.yml up --build postgres`

2. Then, list your local databases:

`make db-list`

3. To list the databases sitting around in the `prod` environment so that you can know which `dbname` to supply in `make cloud-db-export dbname=(which db you want to export)`:

`make cloud-db-list`

4. To export a `prod` database to the `gs://release_db_sql_files/skyviewer/` bucket:

`make cloud-db-export dbname=prod_db`

* The argument `dbname` is required and should be one of the databases listed from `make cloud-db-list`
* You will need to go into the `prod` GCP project in the Google Cloud Storage resource to find the DB dump file
* Once you download the DB dump file, move it to the `./db/` folder

4. To provision a new local database, first bring up the postgres container if it's not already up:

`docker-compose -f docker-compose-local-db.yml up --build postgres`

5. Ensure that the dump file is located within `./db/`, then run:

* Once you download the DB dump file, move it to the `./db/` folder

6. To recreate a local DB from a dump file located within `./db/`:

`make local-db dbname=my_new_local_db dbfile=prod.sql`

* The argument `dbname` is required and will be the name of the newly created database
* The argument `dbfile` is required and should be the name of the DB file to recreate, this file _must_ be in the `./db/` folder

