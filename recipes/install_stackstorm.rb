#
# Cookbook Name:: stackstorm
# Recipe:: install_stackstorm
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Fetches remote packages from StackStorm repository.

include_recipe 'build-essential::default'
include_recipe 'stackstorm::_python'
include_recipe 'git::default'
include_recipe 'stackstorm::default'

node.override['stackstorm']['bin_dir'] = '/usr/bin'
node.override['stackstorm']['python_binary'] = node['python']['binary']

cache_dir = "#{node['stackstorm']['home']}/package_cache"

directory ":create package cache directory #{cache_dir}"  do
  path cache_dir
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

stackstorm_fetch ':install stackstorm packages from St2 repository' do
  path cache_dir
  packages lazy { node['stackstorm']['components'] }
  action :install

  notifies :create, 'file[:backup StackStorm dist configuration]', :immediately
  notifies :create, 'template[:create StackStorm configuration]', :immediately
end

remote_file "#{node['stackstorm']['etc_dir']}/st2-requirements.txt" do
  source 'https://raw.githubusercontent.com/StackStorm/st2/master/requirements.txt'
  mode '0644'
end

python_pip "install St2 requirements.txt system-wide" do
  package_name "-r #{node['stackstorm']['etc_dir']}/st2-requirements.txt"
  action  :install
end

remote_file "#{node['stackstorm']['etc_dir']}/st2client-requirements.txt" do
  source 'https://raw.githubusercontent.com/StackStorm/st2/master/st2client/requirements.txt'
  mode '0644'
  only_if { node['stackstorm']['components'].include?('st2client') }
end

python_pip "install St2 client requirements.txt system-wide" do
  package_name "-r #{node['stackstorm']['etc_dir']}/st2client-requirements.txt"
  action  :install
  only_if { node['stackstorm']['components'].include?('st2client') }
end
