#
# Cookbook Name:: stackstorm
# Recipe:: default
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#
include_recipe 'stackstorm::_packages'
include_recipe 'stackstorm::user'
include_recipe 'stackstorm::config'
include_recipe 'stackstorm::_services'

# Generate username & password for htpasswd flat-file authentication
htpasswd ':add credentials to htpasswd file' do
  file node['stackstorm']['config']['auth_standalone_file']
  user node['stackstorm']['username']
  password node['stackstorm']['password']
  action :add
end
