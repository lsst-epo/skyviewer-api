# Skyviewer Backend/API

The CMS backend that will serve up data/content to the Skyviewer UI/client.

## Installation

1. Build the docker image:

```docker build -t epo/skyviewer_api .``

2. Bring the docker-compose up:

```docker-compose up```

3. Go to http://localhost:9900/admin to test that it loads, if it does return here

4. In a code editor, go into /scripts/run.sh and comment out line 22 as future runs will fail because the DB already exists

This will ensure that the start project will work on your machine.

## Volume

The `docker-compose.yml` mounts the root project folder as a volume for the Craft and Nginx containers. This means that you will be able to make changes to the files within the /craftcms folder and the changes will be instantly reflected in the running container. However, this also means that the containers are no longer ephemeral - which is the intent.