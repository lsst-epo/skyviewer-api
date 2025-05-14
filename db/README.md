# Database Configuration

## Provisioning A Local Database
### Starting From Scratch
If you'd like to build a new database and have no need for any old/existing ones:
1. Aquire the dump file for the new database you'd like to build. You can retrieve this from someone else on the team or from Google Cloud.
2. In `./db/`, swap out your old `skyviewer.sql` dump file for the new one. Make sure the new one is named `skyviewer.sql` if it was named something else initially.
2. Clean up your existing volumes:
    ```
    docker volume prune
    ```

3. Spin up the Docker orchestration as usual: 
    ```
    docker-compose -f docker-compose-local-db.yml up --build
    ```
As long as the filename is correct and matches the bind mount in your `docker-compose-local-db.yaml`, Docker will automatically ingest it. 

### Without Starting from Scratch
There may be times when you'll want to provision a new local database without starting from scratch. To do this:

1. Aquire the dump file for the new database you'd like to build. You can retrieve this from someone else on the team or from Google Cloud. Place the dump file in `./db/`.
2. Bring up the postgres container: 
    ```
    docker-compose -f docker-compose-local-db.yml up --build postgres
    ```
3. Create the new local DB: 
    ```
    make local-db dbname={my_new_local_db} dbfile={my_dump_file.sql}
    ```
    - The argument `dbfile` is required and should be the name of the DB dump file which will be run. This file _must_ be in the `./db/` folder
    - The argument `dbname` is required and will be the name of the newly created database. This can be whatever you choose.
    - Ex. If your dump file is named `newest-skyviewer-db.sql` and you're creating this local database instance on January 30 2025, you could run:
        ```
        make local-db dbname=skyviewer_db_01302025 dbfile=newest-skyviewer-db.sql
        ```
4. Add a bind mount to the `docker-compose-local-db.yml` file under `postgres` > `volumes`
    - Ex. Going off of the example in the previous step, the mapping you would add would look like: `./db/skyviewer_db_01302025.sql:/skyviewer_db_01302025.sql`

5. Spin up the Docker orchestration as usual: 
    ```
    docker-compose -f docker-compose-local-db.yml up --build

## Listing Existing Databases
- To list the local databases:
    - Bring up the postgres container if it's not already up:
        ```
        docker-compose -f docker-compose-local-db.yml up --build postgres
        ```
    - Then, list your local databases: 
        ```
        make db-list
        ```
- To list the prod databases, run: 
    ```
    make cloud-db-list
    ```
    - This is useful for when you need to know which dbname to supply in when exporting prod databases. 

## Exporting a Prod Database
- To export a prod database to the `gs://release_db_sql_files/skyviewer/` bucket: 
    ```
    make cloud-db-export dbname={my_prod_db}
    ```
    - The argument dbname is required and should be the name of one of the databases listed from `make cloud-db-list`
- To retrieve the exported dump file, you will need to go into the `prod` GCP project in the Google Cloud Storage resource.
- Once you download the database dump file, move it to the `./db/` folder and use as needed.