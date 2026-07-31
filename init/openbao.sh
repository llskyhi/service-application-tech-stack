#!/usr/bin/env sh

# BAO_ADDR=http://sats-openbao:8200
export BAO_ADDR=http://localhost:8200

kv_path='sats'
secret_key='db'

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

# bao read \
#     "${kv_path}/${secret_key}"

# bao kv list \
#     -mount="$kv_path"

# bao kv get \
#     -mount="$kv_path" \
#     "$secret_key"
