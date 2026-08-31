#!/usr/bin/env sh

SATS_USER_FIST_NAME="Thefirstname"
SATS_USER_LAST_NAME="Thelastname"
SATS_USER_EMAIL="sats.user@example.com"


echo 'Creating Keycloak user ..'
# Create an user to log in the application as.
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_post_adminrealmsrealmusers
# NOTE: currently (2026-08-27) it's impossible setting user's internal ID via "id" parameter in request body.
# See https://github.com/keycloak/keycloak/discussions/20389
curl \
    -X POST "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/users" \
    -H "${KEYCLOAK_BEARER_HEADER}" \
    -H "Content-Type: application/json" \
    -d "
    {
        \"username\": \"${SATS_USER_USERNAME}\"
    }
    "

echo 'Getting new-created user'\''s internal ID ..'
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_get_adminrealmsrealmusers
SATS_USER_INTERNAL_ID=$(
    curl \
        -s \
        -X GET "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/users?username=${SATS_USER_USERNAME}" \
        -H "${KEYCLOAK_BEARER_HEADER}" \
  | jq -r '.[0].id'
)

echo 'Setting new-created user'\''s basic information and adding password credential ..'
# Update the user, including setting the basic information and a credential for password login.
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_put_adminrealmsrealmusersuser_id
curl \
    -X PUT "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/users/${SATS_USER_INTERNAL_ID}" \
    -H "${KEYCLOAK_BEARER_HEADER}" \
    -H "Content-Type: application/json" \
    -d "
    {
        \"enabled\": true,
        \"email\": \"${SATS_USER_EMAIL}\",
        \"firstName\": \"${SATS_USER_FIST_NAME}\",
        \"lastName\": \"${SATS_USER_LAST_NAME}\",
        \"credentials\": [
            {
                \"type\": \"password\",
                \"value\": \"${SATS_USER_CREDENTIAL_PASSWORD}\"
            }
        ]
    }
    "
