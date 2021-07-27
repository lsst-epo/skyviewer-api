# env-create

env-create is a node.js script that automatically grabs the GCP cloud DB connection information from Google Secret Manager and stuffs it into a .env file which can be copied over to the `<root project folder>/craftcms/` folder. 

## Usage

Usage is simple, ensure that you have the GCloud CLI tool installed:

https://cloud.google.com/sdk/docs/install

If you are prompted for a GCP project to set, use "skyviewer".

Once the GCloud CLI tool is set up, simply run:

`node get-secrets`

The .env file will be created and can be moved to the correct folder with the following command:

`cp ./.env ../craftcms/.env`