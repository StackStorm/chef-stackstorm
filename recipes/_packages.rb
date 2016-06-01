#
# Cookbook Name:: stackstorm
# Recipe:: install_repo
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Fetches remote packages from StackStorm repository.

include_recipe 'stackstorm::_initial'

#%w( git python python-dev libffi-dev libpq-dev).each { |p| package p }

node.override['stackstorm']['bin_dir'] = '/usr/bin'
node.override['stackstorm']['python_binary'] = node['python']['binary']

type = 'deb'
case node['platform_family']
when 'fedora', 'rhel'
  type = 'rpm'
end

packagecloud_repo "StackStorm/stable" do
  type type
end

# Install packages
node['stackstorm']['install_repo']['packages'].each {|p|
  package(p) {version node['stackstorm']['install_stackstorm']['version']}
  }

package 'st2debug' do
  only_if { node['stackstorm']['install_repo']['debug_package'] == true }
end
