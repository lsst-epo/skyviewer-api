# Skyviewer Backend/API

The CMS backend that will serve up data/content to the Skyviewer UI/client.

## Local Installation

1. Go into ```/scripts/run.sh``` and uncomment lines 20-23

2. Build the docker image:

```docker build -t epo/skyviewer_api .```

3. Rename the file ```docker-compose.local.yml``` to ```docker-compose.yml```

4. Bring the docker-compose up:

```docker-compose up```

5. Go back into ```/scripts/run.sh``` and comment out lines 20-23

6. Rebuild the docker image:

```docker build -t epo/skyviewer_api .``

7. Go to http://localhost:9900/admin to test that it loads

This will ensure that the start project will work on your machine.

## Cloud Installation

1. Ask a backend dev to whitelist your public IP address so that the cloud DB will accept traffic from your machine

2. Build the docker image:

```docker build -t epo/skyviewer_api .```

3. Rename the file ```docker-compose.cloud.yml``` to ```docker-compose.yml```

4. Get the GCP DB host IP address and DB password from a backend dev and swap out the carroted values in the ```skyviewer_api``` environment section (ensure < > carrots are removed when you replace the values)

5. Bring the docker-compose up:

```docker-compose up```

6. Go to http://localhost:9900/admin to test that it loads

This will ensure that the start project will work on your machine.

## Volume

The `docker-compose.yml` mounts the root project folder as a volume for the Craft and Nginx containers. This means that you will be able to make changes to the files within the /craftcms folder and the changes will be instantly reflected in the running container. However, this also means that the containers are no longer ephemeral - which is the intent.