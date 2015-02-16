#
# Cookbook Name:: stackstorm
# Recipe:: controller
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Controller recipe installs StackStorm API, auth, sensor_container, history and rules_engine.
# Optionally it installs mistral api and engine.
#

self.send :extend, StackstormCookbook::RecipeHelpers

include_recipe 'stackstorm::default'

case node['stackstorm']['install_method'].to_sym
when :system_wide

  stackstorm_install 'st2 controller' do
    packages %w[ st2reactor st2actions st2api st2auth ]
    action :install
  end

end

template "#{node['stackstorm'][:etc_dir]}/controller.conf" do
  owner 'root' and group 'root'
  mode 0644
  source 'st2.conf.erb'
  variables lazy {
    { 
      config_name: 'controller',
      config: node['stackstorm']['config']
    }
  }
  action :create
end

# Create register content resource
register_content :sensors

selected = %w[ st2api st2sensorcontainer st2history st2rulesengine ]
services = st2_service_config.select {|k,_| selected.include?(k) }

services.each do |service_name, data|
  service_provider = self.service_provider
  template_path = service_init_path(service_name)

  template template_path do
    source "#{service_provider}/st2-init.erb"
    variables lazy {
      Mash.new({
        service_name: service_name,
        runas_user: node['stackstorm']['runas_user'],
        runas_group: node['stackstorm']['runas_group'],
        etc_dir: node['stackstorm']['etc_dir'],
        log_dir: node['stackstorm']['log_dir'],
        config_file: node['stackstorm']['conf_path'],
        python: node['python']['binary']
      }).merge(data)
    }
    action :create   

    # Provider specific options
    case service_provider
    when :debian, :redhat
      mode '0755'
    when :systemd
      notifies :run, "execute[st2-systemctl-daemon-reload]"
    end
  end

  service service_name do
    provider Chef::Provider::Service.const_get(service_provider.to_s.capitalize)
    action [ :enable, :start ]
  end

end
