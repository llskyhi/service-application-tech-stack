# Enable this policy to read database authentication info.
# https://openbao.org/docs/concepts/policies/#policy-syntax
path "sats/kv/data/*" {
    capabilities = ["read"]
}
