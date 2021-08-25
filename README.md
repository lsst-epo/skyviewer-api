# Skyviewer Backend/API

The CMS backend that will serve up data/content to the Skyviewer UI/client.

## Local Installation

These steps assume you have created a local instance of the Skyviewer Craft CMS database. Ensure that your database credentials, etc. match what is in docker-compose.yml

1. Build the docker image:

```docker build -t epo/skyviewer_api .```

2. Bring the docker-compose up:

```docker-compose up```

7. Go to http://localhost:9900/admin to test that it loads

This will ensure that the skyviewer-api project will run on your machine.

## Cloud Installation

Ignore Dockerfile.cloud - it is for deployment to Google Cloud Platform.

1. Ask a backend dev to whitelist your public IP address so that the cloud DB will accept traffic from your machine.

2. Build the docker image:

```docker build -t epo/skyviewer_api .```

3. Rename the file ```docker-compose.yml``` to ```docker-compose.local.yml```

4. Rename the file ```docker-compose.cloud.yml``` to ```docker-compose.yml```

4. Get the GCP DB host IP address and DB password from a backend dev and swap out the carroted values in the ```skyviewer_api``` environment section (ensure < > carrots are removed when you replace the values)

5. Bring the docker-compose up:

```docker-compose up```

6. Go to http://localhost:9900/admin to test that it loads

This will ensure that the skyviewer-api project will run on your machine and be able to access the cloud database.

## Volume

The `docker-compose.yml` mounts the root project folder as a volume for the Craft and Nginx containers. This means that you will be able to make changes to the files within the /craftcms folder and the changes will be instantly reflected in the running container. However, this also means that the containers are no longer ephemeral - which is the intent.

To access a container while it's running:

`docker container ls` to view the running containers and their IDs

under `CONTAINER ID` column, copy the ID associated with the `skyviewer_api` image

then `docker exec -it <container ID> /bin/bash`