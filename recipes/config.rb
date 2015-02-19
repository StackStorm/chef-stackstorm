#
# Cookbook Name:: stackstorm
# Recipe:: config
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'stackstorm::user'

[
  node['stackstorm']['home'],
  node['stackstorm']['etc_dir']
].each do |path|
  directory "creating st2 directory #{path}" do
    path path
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

# Create default user and group to run unprivileged StackStorm services.
user 'st2' do
  home '/home/st2'
  supports manage_home: true
  action :create
end

directory "st2:log_dir" do
  path node['stackstorm']['log_dir']
  owner node['stackstorm']['runas_user']
  group node['stackstorm']['runas_group']
  mode '0755'
  action :create
end

# Backup original st2.conf
file ":backup StackStorm dist configuration" do
  path "#{node['stackstorm'][:etc_dir]}/st2.conf.dist"
  content lazy { ::IO.read("#{node['stackstorm'][:etc_dir]}/st2.conf") }
  not_if { ::File.exist?("#{node['stackstorm'][:etc_dir]}/st2.conf.dist") }
  only_if { ::File.exist?("#{node['stackstorm'][:etc_dir]}/st2.conf") }
  action :create
end

# Write config
template ":create StackStorm configuration" do
  path "#{node['stackstorm'][:etc_dir]}/st2.conf"
  owner 'root' and group 'root'
  mode 0644
  source 'st2.conf.erb'
  variables lazy { {config: node['stackstorm']['config']} }
  action :create
end
