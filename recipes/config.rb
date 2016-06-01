#
# Cookbook Name:: stackstorm
# Recipe:: config
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'stackstorm::user'

# Backup original st2.conf
file ':backup StackStorm dist configuration' do
  path "#{node['stackstorm']['etc_dir']}/st2.conf.dist"
  content lazy { ::IO.read("#{node['stackstorm']['etc_dir']}/st2.conf") }
  not_if { ::File.exist?("#{node['stackstorm']['etc_dir']}/st2.conf.dist") }
  only_if { ::File.exist?("#{node['stackstorm']['etc_dir']}/st2.conf") }
  action :create
end

# Write config
template ':create StackStorm configuration' do
  path "#{node['stackstorm']['etc_dir']}/st2.conf"
  owner 'root'
  group 'root'
  mode 0644
  source 'st2.conf.erb'
  variables lazy { node['stackstorm']['config'] }
  action :create
end

directory 'st2:log_dir' do
  path node['stackstorm']['log_dir']
  owner node['stackstorm']['run_user']
  group node['stackstorm']['run_group']
  mode '0755'
  action :create
end
