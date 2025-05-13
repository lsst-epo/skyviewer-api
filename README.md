# Skyviewer Craft CMS Backend/API


[![Deployed to Production](https://github.com/lsst-epo/skyviewer-api/actions/workflows/build-and-push.yaml/badge.svg)](https://github.com/lsst-epo/skyviewer-api/actions/workflows/build-and-push.yaml)

Headless Craft CMS backend for the Skyviewer web app.

## Set up and run the project
### Prerequisites
1. Install Docker Desktop v2 or later. 
    - This will give you access to the docker-compose command
2. Install Composer for the command line:
    - If you have Homebrew: 
        ```
        brew install composer
        ```
    - Or you can use the installer that Composer provides: https://getcomposer.org/doc/00-intro.md

### Set up
1. Clone the repo
2. At the root level of the project, create a copy of `docker-compose-local-db.sample.yaml` and name it `docker-compose-local-db.yaml`
3. Ask someone on the team for:
    - A database dump file to go in the `./db/` folder
        - Ex. “skyviewer.sql” or “skyviewer_db.sql”
    - The values to fill in the `docker-compose-local.db.yaml`, which should include:
        - The proper user and database values for the Postgres environment
        - The proper user and database values for the Craft environment 
        - A bind mount to map your local database dump file to your Docker container for persistent storage
            - The filename in this mapping must match the filename of your dump file in `./db`
4. Provision your local database
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

5. Once your Postgres setup is complete, we can set up Craft. Navigate to the `/api` folder: 
    ```
    cd api
    ```
6. Install required dependencies:
    ```
    composer install
    ```

### Start API
1. Navigate back out to the root of the project, and bring the Docker Compose orchestration up:
    ```
    cd ..
    docker-compose -f docker-compose-local-db.yaml up --build
    ```
2. Navigate to http://localhost:8080/admin. The Craft dashboard login page should be visible
3. Obtain credentials from someone on the team to log into the Craft CMS backend and begin development.

### Troubleshooting Tips
- If you see postgres errors saying that your local database does not exist:
    - Ensure you have a dump file in `/db` and that it’s named correctly
    - List your local databases to see what’s been created. If you don’t see your database, try running:
        ```
        make local-db dbname={my_new_local_db} dbfile={my_dump_file.sql}
        ```
- If you see craft errors saying craft was unable to find or open something from the /vendor folder: 
    - The `/vendor` folder is where all your Composer dependencies are. If there’s been an update to which dependencies are required, or a change to their versions, it may be the source of this error. 
    - To fix it, you’ll want to rebuild your dependencies:
        ```
        cd api
        composer install
        ```
    - Navigate back out to the root of the project and try bringing up your Docker orchestration again.
        ```
        cd ..
        docker-compose -f docker-compose-local-db.yaml up --build
        ```
- If you see craft errors about undefined tables/relations:
    - Double check with someone else on the team that all your database-related values in your `docker-compose-local-db.yaml` values are correct.


## Useful docker commands for local development

1. Delete errant and bloated volumes: `docker volume prune`
2. Delete stopped and unused containers, networks, and images: `docker system prune`
2. Shut down running containers gracefully: `docker-compose -f docker-compose-local-db.yml down`
3. SSH into a running container:
* `docker container ls`
* `docker exec -it <CONTAINER-ID> /bin/sh`
* If you're SSHing into a PostgreSQL container and want to enter the `psql` CLI: `psql -d craft -U craft`
5. When you need to do composer operations: `docker run -v ${PWD}/api:/app composer <require/remove> <package>`
7. When working locally, in order to ensure the latest docker `craft-base-image` is used: `docker pull us-central1-docker.pkg.dev/skyviewer/public-images/craft-base-image`