# Craft CMS Starter Project

The purpose of this codebase is to function as a programmatic way to create the foundation of a Dockerized Craft CMS backend.

## Quickstart

**To recreate the Craft CMS codebase after you have *already* created it, simply delete the /craftcms folder**

1. Build the docker image:

```docker build -t epo/craft_cms_starter . --build-arg ACTION=install```

You do not need to include `--build-arg ACTION=install` in future builds, it is only required to download/install Craft CMS.

2. Bring the docker-compose up:

```docker-compose up```

3. Go to http://localhost:9900/admin
4. Proceed with installation

This will ensure that the start project will work on your machine.

## Custom Installation

**To recreate the Craft CMS codebase after you have *already* created it, simply delete the /craftcms folder**

AKA create a new project using this starter project.

1. Decide upon a name for your project
2. Build the docker image:

```docker build -t <image name> . --build-arg ACTION=install```

You do not need to include `--build-arg ACTION=install` in future builds, it is only required to download/install Craft CMS.

3. Modify the "craft" image name in the `docker-compose.yml` file:

```<image name>:latest```

3.1 Optional: Rename the database in the docker-compose.yml for both the "craft" container and "postgres" container (See the section below regarding customizing the database name)

4. Bring up the docker-compose:

```docker-compose up```

5. Go to http://localhost:9900/admin
6. Proceed with installation

### Customizing the Codebase
---

#### Folder name

You may want to rename the "craftcms" folder. If you do you will also need to change the nginx default.conf file on the line that defines the root:

`    root /var/www/html/craftcms/web;`

Change "craftcms" to whatever you rename the folder to. For instance, in the case of renaming the craftcms folder to "skyviewer":

`    root /var/www/html/skyviewer/web;`

---

#### Port

If you would like to run Craft on a port other than 9900, change the port mapping in the docker-compose.yml file at `services.nginx.ports`, only change the first number on the left-hand side of the colon. the `:81` is used internally within the container.

---

#### Github

Presumably, you will want to push this code out to Github after running the installation Docker build step and bringing up the compose file for the first time.

However, because this starter proiject is hosted on Github you need to ensure that you do not push your changes out to the start project repo.

You can either:

* Remove the .git folder (hidden) at the project root, then point at the new repo upstream URL
* Copy the contents of this folder to a newly cloned folder for the new repo (make sure you don't copy the .git folder)

---

#### Database

By default, a database named "craft" is created. If you would like to provide a custom database name though, and to do so change the docker-compose.yml file in the following places:

* `services.craft.environment.DB_DATABASE`
* `services.postgres.environment.POSTGRES_DB`
