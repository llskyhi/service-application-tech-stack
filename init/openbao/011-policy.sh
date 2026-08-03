#!/usr/bin/env sh
# Configure the policy to allow the role that application uses to read secrets.

script_dir_path="$(dirname "$0")"

policy_name='sats-policy'
policy_file_path="$script_dir_path/sats.hcl"

bao policy write \
    "$policy_name" \
    "$policy_file_path"
# or:
#cat "$policy_file_path" | \
#bao policy write \
#    "$policy_name" \
#    -
