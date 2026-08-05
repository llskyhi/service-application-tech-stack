#!/usr/bin/env sh
# Enable KV secret engine, set secrets.

kv_path='sats/kv'
secret_key='db'

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
    "$secret_key" \
    username=postgres \
    password=pass

# sample commands that can be used to check result
#bao kv list \
#    -mount="$kv_path"
#bao kv get \
#    -mount="$kv_path" \
#    "$secret_key"
# read raw result?
#bao read \
#    "${kv_path}/${secret_key}"
