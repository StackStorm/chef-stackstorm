#
# Cookbook Name:: stackstorm
# Recipe:: config
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'stackstorm::user'

# Ensure directory for config is available
directory ':create /etc/st2 directory' do
  path '/etc/st2'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Backup original st2.conf
file ':backup StackStorm dist configuration' do
  path '/etc/st2/st2.conf.dist'
  content lazy { ::IO.read('/etc/st2/st2.conf') }
  not_if { ::File.exist?('/etc/st2/st2.conf.dist') }
  only_if { ::File.exist?('/etc/st2/st2.conf') }
  action :create
end

# Write config
template ':create StackStorm configuration' do
  path '/etc/st2/st2.conf'
  owner 'root'
  group 'root'
  mode 0644
  source 'st2.conf.erb'
  variables lazy { node['stackstorm']['config'] }
  action :create
end
