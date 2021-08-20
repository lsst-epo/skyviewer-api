<?php

// Import the Secret Manager client library.
use Google\Cloud\SecretManager\V1\SecretManagerServiceClient;

/** Uncomment and populate these variables in your code */
$projectId = 'skyviewer';
$secretId = 'skyviewer_db_private_ip';
$versionId = 'latest';

// Create the Secret Manager client.
$client = new SecretManagerServiceClient();

// Build the resource name of the secret version.
$name = $client->secretVersionName($projectId, $secretId, $versionId);

// Access the secret version.
$response = $client->accessSecretVersion($name);

// Print the secret payload.
//
// WARNING: Do not print the secret in a production environment - this
// snippet is showing how to access the secret material.
$payload = $response->getPayload()->getData();
print("Rosas");
printf('Plaintext: %s', $payload);
putenv("DB_SERVER=" . $payload);
?>