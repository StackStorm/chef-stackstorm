#
# Cookbook Name:: stackstorm
# Recipe:: bundle
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# StackStorm "all in one" recipe deploys st2 roles as well as dependant
# services which are mongodb, rabbitmq and postgressql(used by mistral).
#

pubkey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4kFg0ZNmdrSqFvP+kZbVDlOdxzKgkcg3tKT19JTAKljpQCqUcZAEIthp8KsesXmAErZ8ykOEuYRCjug4Wd9uyXeewg5SgJy2gz/0biCAToJ71XxrPMM5SgVk/0sWxRIbmkU7+gNga6OIcimNxH5flESRAQx+C1kD1sBMfPeJzMa48kZWKBpaScguWka1N1rVn7nDza7srqPn+7NmQDVF/+VkMOxCEJcbIXdc0hYzebatWklYIcoSuF0WETYJxmKCoL8stTFucCxDXzbPvwGL5WctdZKcu7MeAaodH8V3x7aCujXzsSILtU7mc7uewuM2iT3nukLqYOk6W4UFRBk8n'
prikey = %(-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAuJBYNGTZna0qhbz/pGW1Q5TnccyoJHIN7Sk9fSUwCpY6UAql
HGQBCLYafCrHrF5gBK2fMpDhLmEQo7oOFnfbsl3nsIOUoCctoM/9G4ggE6Ce9V8a
zzDOUoFZP9LFsUSG5pFO/oDYGujiHIpjcR+X5REkQEMfgtZA9bATHz3iczGuPJGV
igaWknILlpGtTda1Z+5w82u7K6j5/uzZkA1Rf/lZDDsQhCXGyF3XNIWM3m2rVpJW
CHKErhdFhE2CcZigqC/LLUxbnAsQ182z78Bi+VnLXWSnLuzHgGqHR/Fd8e2gro18
7EiC7VO5nO7nsLjNok957pC6mDpOluFBUQZPJwIDAQABAoIBAHVoDVQ3G1/8emJd
GlqgALEfFiQERqn4i/dkFqN3dpoleq7UNrhavXWnMi3uoNp7pqUTNYRbOYPhZ05f
2vpcALv0lKBq8671fUchSCetbopN0RDSESHgMD+33OiG0g+0QgSGRzQLDm3/22bA
egXKTTwArYjbqj32wZgJDAEBwv33dckJLVEqnq1o54XNZpCGXw8LUJTlNCwWVzoA
S+/nKClV333x6x5UZnyc4N3iUS4//T25lDLWXHCwGBQyOFIvqS1fzDa9/9qGKpns
fqAnXxvZwMHat008cQcWgJ9ripLVO2aG8+slR1JL3qNgNBLAKOnVe8akLMW+azOn
vGlsz+ECgYEA4wrNySwHRdlmd9s9y9QwIEA66Lt8QDRRoW5Kd6eJMTGpbz7ffnF2
Fw6Zy6JOSyi5p8PfiD0H5A1EqrboFoF50jJ5rmG6IwtUJFbWLrN1zaREDta2xuFQ
fmtPxkXNOK9RkdW1m4j1cXpF9F1QylIzhvkkp45d4lOPWvc3oBpePmkCgYEA0BqS
eaOxbe1aZD+jiKu9WrmfkLc7Ch6KFV9ziuno0ZfZ740FQJk3diVBC7B0/MKUMlqF
Ag98wkKAGGyVDpMKtMkxRSXMnTGPbuEuyDmdM/XKVsE9JAJgvrbDiQHFkZPQRqEf
JSFLN7hTBJyIDIakQEZQZ4d8eUY1OBDgZA8Ejw8CgYAyX/pK0W8Hq3XV0BpE+F55
OWcYrkiiQjl+dOcm51BETv2GBlA2UNxfv0iWavuuJ2oR9B7LrqbqjZsXuZ+DJtUt
sy9WZq6TCfdwXKgHEqBnsTO8ix1gwStH8W1w05n2IsgZcG5sBRZYSEXvMykyysxN
/UeJucfQ6LNc/o8kAdW5SQKBgC5q3uUW6AqW+KSHtVhUxkWoRbknxZl6Ol6ODd2c
Uvv9HPVbxSIlisNlh96tm0qNtDSPED/naHKEFsJb5dt8XNT6U20TA1LErTOUMrUi
dLgUSO+U5qhTh3TCm1bB+GmCSOCYK7RCet6Q1KOgro/ssFJN3L1a8R6z1EcPLJ3k
46VtAoGAQcW0Ip7+8zrvQbHp3uLAjJskhYZTAKDI/REKrhdsL22OTF6H4lOObGPL
8Ph7hy2BqJOtuzSoYfHl5Kci4/qcJ5TBYItrxYPo/JVxcB25xtSRCv7rtfpJuC2O
q5MwK3rNIoQ1EBTc7DVIVm9WV11Py3x7FfZb4eQzhFPZFQsV9n0=
-----END RSA PRIVATE KEY-----
)

node.override['stackstorm']['roles'] = %w(controller worker client)
node.default['stackstorm']['user']['ssh_pub'] = pubkey
node.default['stackstorm']['user']['ssh_key'] = prikey
node.default['stackstorm']['user']['authorized_keys'] = [pubkey]

include_recipe 'stackstorm::_initial'
include_recipe 'stackstorm::_packages'
include_recipe 'mongodb3::default'
include_recipe 'rabbitmq::default'
include_recipe 'stackstorm::default'
include_recipe 'stackstorm::mistral'
