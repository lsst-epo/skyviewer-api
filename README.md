# Skyviewer Backend/API

The CMS backend that will serve up data/content to the Skyviewer UI/client.

## Running locally with Docker Compose

For local development, you can choose to either connect to the development database running in Google Cloud Platform,
or a local database.

### Cloud SQL Dev DB

These steps assume that you already have [Docker](https://docs.docker.com/get-docker/),
[Docker Compose](https://docs.docker.com/compose/install/),
and the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) already installed and setup.

By default this will use an SSH tunnel to connect to the Cloud SQL development database instance.

__One-time Setup__: In order to download container images from GCR you will need to configure the Docker
daemon to authenticate to GCR. The easiest way to do this is to run `gcloud auth configure-docker`. However,
there are other [authentication methods](https://cloud.google.com/container-registry/docs/advanced-authentication)
available if needed.

1. Set the secure config vars. You will need access to view secrets in the `Skyviewer` GCP project:

    ```bash
    export $(gcloud secrets versions access latest --secret=skyviewer-api-env-dev --project=skyviewer | grep DB_PASSWORD)

    export $(gcloud secrets versions access latest --secret=skyviewer-api-env-dev --project=skyviewer | grep SECURITY_KEY)
    ```

2. Bring the docker-compose up:

   Note that it make take 1 or 2 restarts of the craft container before the SSH tunnel is up and Craft is able to launch. The Craft container is configured to auto-restart if the initial database connection fails.

    *To connect to the development database*:

    ```bash
    docker-compose up --build
    ```

    *To connect to the integration database*:

    ```bash
    docker-compose -f docker-compose.yml -f integration.yml up
    ```

3. Go to <http://localhost:8080/admin> to test that it loads

This will ensure that the skyviewer-api project will run on your machine.

### Local Dev DB

The local development DB will be created from a database backup hosted in Google Cloud Storage (ask another dev where to look) on the initial container image build. Thereafter, any updates made will persist only as long as the containter is not deleted (e.g. `docker delete` or `docker-compose down`). Copy down the `.sql` dump file from GCS into the `/local-db` folder by following the instructions in the "Coping a DB from Cloud SQL" below, then proceed with the following steps:

1. EPO-developed Craft plugins need to be installed from Github, which requires for you to create an OAuth token and store it in `~/.composer/auth.json`. Go to `https://github.com/settings/tokens/` in your browser and create a new token. NOTE: You will only be have the chance to copy the token once after you create it, you will need to generate a new token should you need to copy/paste the token again if you navigate away from this page. Copy the token value and paste the following in to `~/.composer/auth.json`:

```json
{
    "github-oauth": {
        "github.com": "<token value>"
    }
}
```

2. Bring the docker-compose up. _Note that without the_ `-f docker-compose-local-db.yml` _option you will connect to the Cloud SQL database instead of a local DB_:

    ```bash
    docker-compose -f docker-compose-local-db.yml up
    ```

3. Go to <http://localhost:8080/admin> to test that it loads

#### Copying a DB from Cloud SQL

It may occassinally be necessary to replace the local db with a copy of the development db from Cloud SQL. This is achieved by taking an export of the database from a Cloud SQL instance then then downloading the export locally and importing it to the local database.

1. Create a DB export in Cloud SQL.

   ```bash
   gcloud sql export sql --project skyviewer skyviewer-replica gs://skyviewer/skyviewer-export.sql --database=skyviewer
   ```

2. Download the export

   ```bash
   gsutil cp gs://skyviewer/skyviewer-export.sql ./local-db/skyviewer.sql
   ```

3. Modify the top of the sql dump file to include the command to create the DB:
```
CREATE DATABASE skyviewer;
\c skyviewer
```

### Volume

The `docker-compose.yml` mounts the CraftCMS `web` folder as a volume for the Craft and Nginx container. This means that you will be able to make changes to the files within the `/craftcms/web` folder and the changes will be instantly reflected in the running container. However, this also means that the containers are no longer ephemeral - which is the intent.

---

## Cloud Run

### Configuration

This image accepts application configuration in the form of an ```.env``` file in ```/var/secrets```. The below table describes the variables accepted, and the default value (if applicible).

| Variable Name | Default Value | Description |
| --- | --- | --- |
| `APP_ID` | `CraftCMS` | The CraftCMS application id. |
| `CP_TRIGGER` | `admin` | The URI segment that triggers the control panel. |
| `DB_DATABASE` | N/A | The name of the application database. |
| `DB_DRIVER` | N/A | The database driver. |
| `DB_PASSWORD` | N/A | The password for `DB_USER`. |
| `DB_PORT` | N/A | The database server port. |
| `DB_SCHEMA` | N/A | The database schema. |
| `DB_SERVER` | N/A | The hostname or IP address of the database server. |
| `DB_USER` | N/A | The username of the database user. |
| `ENABLE_MEMCACHED` | `false` | Set to `true` to enable memcached caching for session data. |
| `ENVIRONMENT` | `production` | The runtime environment. |
| `MEMCACHED_IP` | N/A | The IP address (or hostname) of the memcached instance. *Only used if `ENABLE_MEMCACHED` is `true`.* |
| `MEMCACHED_PORT` | `11211` | The port to connect to memcached on. *Only used if `ENABLE_MEMCACHED` is `true`.* |
| `PRIMARY_SITE_URL` | N/A | The base URL of the application. |
| `SECURITY_KEY` | N/A | The application security key. |

To access a container while it's running:

`docker container ls` to view the running containers and their IDs

under `CONTAINER ID` column, copy the ID associated with the `skyviewer_api` image

then `docker exec -it <container ID> /bin/bash`
