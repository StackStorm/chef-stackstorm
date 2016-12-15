#
# Cookbook Name:: stackstorm
# Recipe:: _repository
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'apt'

type = case node['platform_family']
       when 'rhel'
         'rpm'
       else
         'deb'
       end

# Read:
#  http://blog.packagecloud.io/eng/2016/03/21/apt-hash-sum-mismatch/
#  https://packagecloud.io/computology/apt-backport
package 'apt' do
  version '1.2.10'
  action :nothing
end

execute 'Ubuntu Precise and Trusty: APT hash sum mismatch workaround' do
  command 'curl -s https://packagecloud.io/install/repositories/computology/apt-backport/script.deb.sh | bash'
  only_if { node['platform'] == 'ubuntu' }
  only_if { %w(trusty precise).include? node['lsb']['codename'] }
  creates '/etc/apt/sources.list.d/computology_apt-backport.list'
  notifies :install, 'package[apt]', :immediately
end

packagecloud_repo 'StackStorm/stable' do
  type type
end
