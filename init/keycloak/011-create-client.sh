#!/usr/bin/env sh

echo 'Creating OIDC client ..'
# Create a "client" (by terms of OIDC) that the application can log in as.
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_post_adminrealmsrealmclients
curl \
    -X POST "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/clients" \
    -H "$KEYCLOAK_BEARER_HEADER" \
    -H "Content-Type: application/json" \
    -d "
    {
        \"clientId\": \"${SATS_OIDC_CLIENT_ID}\",
        \"protocol\": \"openid-connect\",
        \"standardFlowEnabled\": true,
        \"redirectUris\": [
            \"${SATS_APPLICATION_URL}/auth/callback\"
        ],
        \"attributes\": {
            \"post.logout.redirect.uris\": \"${SATS_APPLICATION_URL}/auth/post-logout\"
        }
    }
    "

echo 'Getting new-created client'\''s internal ID ..'

# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_get_adminrealmsrealmclients
oidc_client_info=$(
    curl \
        -s \
        -X GET "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/clients?clientId=${SATS_OIDC_CLIENT_ID}" \
        -H "$KEYCLOAK_BEARER_HEADER"
)
SATS_OIDC_CLIENT_INTERNAL_ID=$(
    echo "$oidc_client_info" \
  | jq -r '.[0].id'
)

echo 'Setting new-created client'\''s secret ..'
# Set the client secret to known one (instead of randomly generating one).
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_put_adminrealmsrealmclientsclient_uuid
# NOTE: to randomly generate client secret, use POST /admin/realms/{realm}/clients/{client-uuid}/client-secret
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_post_adminrealmsrealmclientsclient_uuidclient_secret
curl \
    -X PUT "${SATS_KEYCLOAK_URL}/admin/realms/${SATS_KEYCLOAK_REALM_NAME}/clients/${SATS_OIDC_CLIENT_INTERNAL_ID}" \
    -H "$KEYCLOAK_BEARER_HEADER" \
    -H "Content-Type: application/json" \
    -d "
    {
        \"publicClient\": false,
        \"secret\": \"${SATS_OIDC_CLIENT_SECRET}\"
    }
    "
