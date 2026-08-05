#!/usr/bin/env sh
# Enable the approle auth method and add a role with fixed role_id/secret_id.

policy_name=sats-policy
approle_mount_path='sats-approle'
sats_role_name='sats-role'
sats_role_id='01234567-89ab-cdef-0123-4567890abcde'
sats_secret_id='edcba098-7654-3210-fedc-ba9876543210'

bao auth enable \
    -path="$approle_mount_path" \
    approle
# Add a role with specific name.
# https://openbao.org/api-docs/auth/approle/#createupdate-approle
# https://openbao.org/docs/concepts/tokens/#token-type-comparison
# (optional) token_type=batch: generates lightweight token, should be enough for reading operations only?
# (optional) secret_id_num_uses=0: unlimited times that role_id/secret_id pair generated (without explicitly configuration) can be used by application.
bao write \
    -f \
    "auth/$approle_mount_path/role/$sats_role_name" \
    token_policies="$policy_name"

# Specify fixed role_id/secret_id, for this project's demo purpose.
# https://openbao.org/api-docs/auth/approle/#update-approle-role-id
bao write \
    "auth/$approle_mount_path/role/$sats_role_name" \
    role_id="$sats_role_id"
# https://openbao.org/api-docs/auth/approle/#create-custom-approle-secret-id
bao write \
    "auth/$approle_mount_path/role/$sats_role_name/custom-secret-id" \
    secret_id="$sats_secret_id"

# https://openbao.org/docs/auth/approle/#configuration
# https://openbao.org/api-docs/auth/approle/#read-approle-role-id
# https://openbao.org/api-docs/auth/approle/#generate-new-secret-id
# In real applications, the role_id and secret_id should be generated (instead of specified) like below:
#bao read \
#    auth/$approle_mount_path/role/$sats_role_name/role-id
#bao write \
#    -f \
#    "auth/$approle_mount_path/role/$sats_role_name/secret-id"
