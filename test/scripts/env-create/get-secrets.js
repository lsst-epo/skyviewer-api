const axios = require('axios');
const { exec } = require("child_process");
const fs = require("fs");

let dbIp = "";
let dbUser = "";
let dbPass = "";
let craftSecurityKey = "";
let dbIpHeaders = {};

exec("gcloud auth print-access-token", async (error, stdout, stderr) => {
    if(error) {
        console.log("It doesn't look like the GCloud GCP CLI is installed.");
        console.log("The GCloud CLI can be found here: https://cloud.google.com/sdk/docs/install");
        return;
    }

    if(stderr) console.log(-1);

    console.log(`GCloud Access Token: ${stdout}`);
    
    let authToken = "Bearer " + stdout.replace(/\r?\n|\r/g, '');
    dbIpHeaders = {
        headers: {
            "authorization" : authToken,
            "content-type" : "application/json",
            "x-goog-user-project" : "skyviewer"
        }
    }

    setCraftSecurityKey();
 
});

function setCraftSecurityKey() {
    axios.get(getSecretUrl("skyviewer_craft_security_key"), dbIpHeaders)
        .then(function (response) {
        // handle success
        console.log("Retrieved Craft security key");
        craftSecurityKey = Buffer.from(response.data.payload.data, "base64").toString();
        setDbPass();
        })
        .catch(function (error) {
        // handle error
        console.log(error);
        });
}

function setDbPass() {
    axios.get(getSecretUrl("skyviewer_db_pass"), dbIpHeaders)
        .then(function (response) {
        // handle success
        console.log("Retrieved database password");
        dbPass = Buffer.from(response.data.payload.data, "base64").toString();
        setDbUser();
        })
        .catch(function (error) {
        // handle error
        console.log(error);
        });
}

function setDbUser() {
    axios.get(getSecretUrl("skyviewer_db_user"), dbIpHeaders)
        .then(function (response) {
        // handle success
        console.log("Retrieved database username");
        dbUser = Buffer.from(response.data.payload.data, "base64").toString();
        setDbIp();
        })
        .catch(function (error) {
        // handle error
        console.log(error);
        });
}

function setDbIp() {
    axios.get(getSecretUrl("skyviewer_db_ip"), dbIpHeaders)
        .then(function (response) {
            // handle success
            console.log("Retrieved database IP");
            dbIp = Buffer.from(response.data.payload.data, "base64").toString();
            createEnvFile();
        })
        .catch(function (error) {
            // handle error
            console.log(error);
        });
}

function getSecretUrl(secret) {
    return `https://secretmanager.googleapis.com/v1/projects/skyviewer/secrets/${secret}/versions/1:access`;
}

function createEnvFile() {
    let content =   "# The environment Craft is currently running in (dev, staging, production, etc.)\n" +
                    "ENVIRONMENT=dev\n\n" +
                    "# The application ID used to to uniquely store session and cache data, mutex locks, and more\n" +
                    "APP_ID=CraftCMS--fb512aa9-7e66-42fd-b311-27165912e30e\n\n" +
                    "# The secure key Craft will use for hashing and encrypting data\n" +
                    `SECURITY_KEY=${craftSecurityKey}\n\n` +
                    "# Database Configuration\n" +
                    "DB_DRIVER=pgsql\n" +
                    `DB_SERVER=${dbIp}\n` +
                    "DB_PORT=5432\n" +
                    "DB_DATABASE=skyviewer\n" +
                    `DB_USER=${dbUser}\n` +
                    `DB_PASSWORD=${dbPass}\n` +
                    "DB_SCHEMA=public\n" +
                    "DB_TABLE_PREFIX=\n\n" +
                    "# The URI segment that tells Craft to load the control panel\n" +
                    "CP_TRIGGER=admin\n";
    
    fs.writeFile("./.env", content, null, (err) => {
        if(err) return console.log(err);

        console.log(".env file created! Copy this file over to ../craftcms/ to use Craft:\n");
        console.log("cp ./.env ../craftcms/.env");
    })
}