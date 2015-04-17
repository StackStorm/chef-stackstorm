#
# Cookbook Name:: stackstorm
# Recipe:: default
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Recipe brings up StackStorm system services.
#

self.send :extend, StackstormCookbook::RecipeHelpers

include_recipe "stackstorm::install_#{node['stackstorm']['install_method']}"
include_recipe 'stackstorm::config'

# Apply st2 components
components = apply_components

# register sensors
register_content(:sensors) if components.include?('st2actions')

components.each do |component|
  services = node['stackstorm']['component_provides'][component] || []

  services.each do |service_name|
    # actionrunner service is handled in actionrunners recipe
    next if service_name == 'st2actionrunner'
    service_bin = node['stackstorm']['service_binary'][service_name] || service_name
    service_bin = "#{node['stackstorm']['bin_dir']}/#{service_bin}"

    stackstorm_service service_name do
      variables lazy {
        Mash.new({
          service_name: service_name,
          run_user: node['stackstorm']['run_user'],
          run_group: node['stackstorm']['run_group'],
          service_bin: service_bin,
          etc_dir: node['stackstorm']['etc_dir'],
          log_dir: node['stackstorm']['log_dir'],
          config_file: node['stackstorm']['conf_path'],
          python: node['stackstorm']['python_binary']
        })
      }
    end

  end
end

if components.include?('st2actions')
  include_recipe 'stackstorm::actionrunners'
end
