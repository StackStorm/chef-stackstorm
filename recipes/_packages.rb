#
# Cookbook Name:: stackstorm
# Recipe:: install_repo
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Fetches remote packages from StackStorm repository.

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

# Install packages
node['stackstorm']['install_repo']['packages'].each { |p| package p }

# Apply st2 components
send :extend, StackstormCookbook::RecipeHelpers
components = apply_components

components.each do |component|
  services = node['stackstorm']['component_provides'][component] || []

  services.each do |service_name|
    # actionrunner service is handled in actionrunners recipe
    next if service_name == 'st2actionrunner'
    service "#{recipe_name} enable and start StackStorm service #{service_name}" do
      service_name service_name
      action [:enable, :start]
    end
  end
end

include_recipe 'stackstorm::actionrunners' if components.include?('st2actions')
