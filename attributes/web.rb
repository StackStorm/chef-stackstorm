#
# Cookbook Name:: stackstorm
# Attributes:: web
#

# Self-signed certificate
default['stackstorm']['ssl']['self_signed']['enabled'] = false
default['stackstorm']['ssl']['self_signed']['org'] = 'StackStorm'
default['stackstorm']['ssl']['self_signed']['org_unit'] = 'Information Technology'
default['stackstorm']['ssl']['self_signed']['country'] = 'US'
