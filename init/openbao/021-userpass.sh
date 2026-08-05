#!/usr/bin/env sh
# Enable the "userpass" auth method, create a user
# https://openbao.org/docs/auth/userpass/#configuration

policy_name='sats-policy'

userpass_mount_path='sats-userpass'
userpass_username='sats-user'
userpass_password='sats-pass'

bao auth enable \
    -path="$userpass_mount_path" \
    userpass

bao write \
    "auth/$userpass_mount_path/users/$userpass_username" \
    password="$userpass_password" \
    token_policies="$policy_name"
