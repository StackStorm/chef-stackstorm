#
# Cookbook Name:: stackstorm
# Recipe:: install_repo
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Fetches remote packages from StackStorm repository.

include_recipe 'stackstorm::_initial'

node.override['stackstorm']['bin_dir'] = '/usr/bin'

type = case node['platform_family']
       when 'rhel'
         'rpm'
       else
         'deb'
       end

packagecloud_repo 'StackStorm/stable' do
  type type
end

# Install packages
node['stackstorm']['install_repo']['packages'].each { |p| package p }

package 'st2debug' do
  only_if { node['stackstorm']['install_repo']['debug_package'] == true }
end

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
