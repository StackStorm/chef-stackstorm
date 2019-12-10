#
# Cookbook Name:: stackstorm
# Recipe:: default
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#
include_recipe 'stackstorm::_repository'
package 'st2'
include_recipe 'stackstorm::user'
include_recipe 'stackstorm::config'
include_recipe 'stackstorm::_services'

# Generate username & password for htpasswd flat-file authentication
if node['stackstorm']['config']['auth_backend'] == 'flat_file'
  htpasswd ':add credentials to htpasswd file' do
    file node['stackstorm']['config']['auth_backend_kwargs']['file_path']
    user node['stackstorm']['username']
    password node['stackstorm']['password']
    action :add
  end
end
