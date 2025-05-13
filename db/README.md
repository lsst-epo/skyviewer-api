# Database Configuration

## Provisioning Your Local Database
1. Bring up the postgres container: 
    ```
    docker-compose -f docker-compose-local-db.yml up --build postgres
    ```
2. To create a local DB from a dump file located within `./db/`: 
    ```
    make local-db dbname={my_new_local_db} dbfile={my_dump_file.sql}
    ```
    - The argument `dbfile` is required and should be the name of the DB dump file which will be run. This file _must_ be in the `./db/` folder
    - The argument `dbname` is required and will be the name of the newly created database. This can be whatever you choose.
    - Ex. If your dump file is named `skyviewer.sql`, you could run...
        ```
        make local-db dbname=skyviewer_{mmddyyyy} dbfile=skyviewer.sql
        ```
        ...where `mmddyy` corresponds to the current date. 

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