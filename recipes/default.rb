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

components = apply_components
runners = !components.delete('st2actions').nil?

# register sensors
register_content(:sensors) if components.include?('st2actions')

components.each do |component|
  services = node['stackstorm']['component_provides'][component] || []

  services.each do |service_name|
    service_bin = node['stackstorm']['service_binary'][service_name] || service_name
    service_bin = "#{node['stackstorm']['bin_dir']}/#{service_bin}"

    stackstorm_service service_name do
      variables lazy {
        Mash.new({
          service_name: service_name,
          runas_user: node['stackstorm']['runas_user'],
          runas_group: node['stackstorm']['runas_group'],
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

if runners
  include_recipe 'stackstorm::actionrunners'
end
