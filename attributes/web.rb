#
# Cookbook Name:: stackstorm
# Attributes:: web
#

# Self-signed certificate
default['stackstorm']['web']['ssl']['self_signed']['enabled'] = false
default['stackstorm']['web']['ssl']['self_signed']['org'] = 'StackStorm'
default['stackstorm']['web']['ssl']['self_signed']['org_unit'] = 'Information Technology'
default['stackstorm']['web']['ssl']['self_signed']['country'] = 'US'
