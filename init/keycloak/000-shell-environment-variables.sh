#!/usr/bin/env sh

export SATS_APPLICATION_URL="http://localhost:8080"
export SATS_KEYCLOAK_URL="http://localhost:8070"
export SATS_KEYCLOAK_REALM_NAME="sats-realm"
export SATS_OIDC_CLIENT_ID="sats-client"
export SATS_OIDC_CLIENT_SECRET="sats-client-secret"
export SATS_USER_USERNAME="sats-user"
export SATS_USER_CREDENTIAL_PASSWORD="pass"

echo 'Getting Keycloak admin access token ..'
KEYCLOAK_ADMIN_USERNAME="kcadmin"
KEYCLOAK_ADMIN_PASSWORD="kcadmin"
# NOTE:
# This takes advantage of the "admin-cli" client, which is created for every realm by default.
# The endpoint can be discovered at the master realm, i.e. /realms/master/.well-known/openid-configuration .
# It also relies on the configuration that admin user exists and has a "password" -typed credential.
KEYCLOAK_ADMIN_TOKEN="$(
    curl -X POST "${SATS_KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=admin-cli" \
        -d "grant_type=password" \
        -d "username=${KEYCLOAK_ADMIN_USERNAME}" \
        -d "password=${KEYCLOAK_ADMIN_PASSWORD}" \
  | jq -r '.access_token'
)"
# TODO: accessTokenLifespan ?

# usage: curl -H "$KEYCLOAK_BEARER_HEADER" ...
export KEYCLOAK_BEARER_HEADER="Authorization: Bearer ${KEYCLOAK_ADMIN_TOKEN}"
