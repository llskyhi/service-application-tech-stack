#!/usr/bin/env sh

echo 'Creating realm ..'
# https://www.keycloak.org/docs-api/latest/rest-api/index.html#_post_adminrealms
curl \
    -X POST "${SATS_KEYCLOAK_URL}/admin/realms" \
    -H "$KEYCLOAK_BEARER_HEADER" \
    -H "Content-Type: application/json" \
    -d "
    {
        \"realm\": \"${SATS_KEYCLOAK_REALM_NAME}\",
        \"enabled\": true
    }
    "
