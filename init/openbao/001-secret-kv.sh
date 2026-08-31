#!/usr/bin/env sh
# Enable KV secret engine, set secrets.

kv_path='sats/kv'
secret_key_db='db'
secret_key_oidc_client='oidc-client'
sats_oidc_client_secret='sats-client-secret'

# using KV v2

bao secrets enable \
    -path="$kv_path" \
    -version=2 \
    kv
bao secrets tune \
    -description='A example KV engine for SATS (service application tech stack) playground.' \
    "$kv_path"
bao kv put \
    -mount="$kv_path" \
    "$secret_key_db" \
    username=postgres \
    password=pass

bao kv put \
    -mount="$kv_path" \
    "$secret_key_oidc_client" \
    "client-secret=$sats_oidc_client_secret"

# sample commands that can be used to check result
#bao kv list \
#    -mount="$kv_path"
#bao kv get \
#    -mount="$kv_path" \
#    "$secret_key"
# read raw result?
#bao read \
#    "${kv_path}/${secret_key}"
