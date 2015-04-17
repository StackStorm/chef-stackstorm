#
# Cookbook Name:: stackstorm
# Recipe:: install_repo
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Fetches remote packages from StackStorm repository.

include_recipe 'stackstorm::_initial'

node.override['stackstorm']['bin_dir'] = '/usr/bin'
node.override['stackstorm']['python_binary'] = node['python']['binary']

# Add StackStorm repository
case node['platform_family']
when 'debian'
  apt_repository "downloads.stackstorm.net" do
    uri node['stackstorm']['install_repo']['base_url']
    distribution "#{node['lsb']['codename']}_#{node['stackstorm']['install_repo']['suite']}"
    key "#{node['stackstorm']['install_repo']['base_url']}/pubkey.gpg"
    components ['main']
  end
when 'fedora', 'rhel'
  yum_repository 'downloads.stackstorm.net' do
    description "StackStorm offical package repository"
    baseurl node['stackstorm']['install_repo']['base_url']
    gpgcheck false
    # gpgkey "#{node['stackstorm']['install_repo']['base_url']}/pubkey.gpg"
    action :create
  end
end

# Install packages
node['stackstorm']['install_repo']['packages'].each {|p| package p}

package 'st2debug' do
  only_if { node['stackstorm']['install_repo']['debug_package'] == true }
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
