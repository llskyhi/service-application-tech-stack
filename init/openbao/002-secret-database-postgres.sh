#!/usr/bin/env sh
# Enable secret engine, set secrets.

database_path='sats/database'
database_connection='sats-connection'
database_role='sats-database-role'

bao secrets enable \
    -path="$database_path" \
    database

# Add a "connection" with the "root user" credentials.
bao write \
    "$database_path/config/$database_connection" \
    plugin_name='postgresql-database-plugin' \
    connection_url='postgresql://{{username}}:{{password}}@sats-postgres:5432/sats' \
    username='postgres' \
    password='pass' \
    allowed_roles="$database_role"

# TODO: rotate the root user

# Add a "role" that will be used to connect to the connection.
# NOTE: for "static roles", the URL seems to be `.../static-roles/...` instead of `.../roles/...` .
# NOTE: as sequences created by dynamic user cannot be dropped by other dynamic user (Postgres complains "ERROR: must be owner of sequence"),
#       with this credentials method, the `quarkus.hibernate-orm.schema-management.strategy` property cannot be "drop-and-create".
bao write \
    "$database_path/roles/$database_role" \
    db_name="$database_connection" \
    creation_statements='
        CREATE ROLE "{{name}}"
        WITH LOGIN PASSWORD '\''{{password}}'\''
        VALID UNTIL '\''{{expiration}}'\''
        ;
        GRANT ALL PRIVILEGES
        ON SCHEMA "public"
        TO "{{name}}"
        ;
        GRANT ALL PRIVILEGES
        ON ALL SEQUENCES IN SCHEMA "public"
        TO "{{name}}"
        ;
        GRANT ALL PRIVILEGES
        ON DATABASE "sats"
        TO "{{name}}"
        ;
        GRANT ALL PRIVILEGES
        ON ALL TABLES IN SCHEMA "public"
        TO "{{name}}"
        ;
    '
