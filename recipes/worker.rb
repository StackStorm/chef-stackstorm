#
# Cookbook Name:: stackstorm
# Recipe:: controller
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Worker recipe installs StackStorm action runners and mistarl executors.
#

self.send :extend, StackstormCookbook::RecipeHelpers

include_recipe 'stackstorm::default'

case node['stackstorm']['install_method'].to_sym
when :system_wide

  stackstorm_install 'st2 worker' do
    packages %w(st2actions)
    action :install
  end

end

# Create register content resource
register_content :actions

service_provider = self.service_provider
data = st2_service_config['st2actionrunner']

template service_init_path('st2actionrunner') do
  source "#{service_provider}/st2-action-runner.erb"
  action :create
  variables lazy {
    Mash.new({
      service_name: 'st2actionrunner',
      runas_user: node['stackstorm']['runas_user'],
      runas_group: node['stackstorm']['runas_group'],
      etc_dir: node['stackstorm']['etc_dir'],
      log_dir: node['stackstorm']['log_dir'],
      config_file: node['stackstorm']['conf_path'],
      python: node['python']['binary']
    }).merge(data)
  }
  # Provider specific options
  case service_provider
  when :debian, :init
    mode '0755'
  end
end

# Create action runners
1.upto( node['stackstorm']['action_runners'].to_i ).each do |n|
  template_path = service_init_path("st2actionrunner-#{n}")

  template template_path do
    source "#{service_provider}/st2-action-runner-i.erb"
    action :create
    variables lazy {
      Mash.new({
        service_name: "st2actionrunner-#{n}",
        runas_user: node['stackstorm']['runas_user'],
        runas_group: node['stackstorm']['runas_group'],
        etc_dir: node['stackstorm']['etc_dir'],
        log_dir: node['stackstorm']['log_dir'],
        config_file: node['stackstorm']['conf_path'],
        python: node['python']['binary']
      }).merge(data)
    }
    # Provider specific options
    case service_provider
    when :debian, :init
      mode '0755'
    when :systemd
      notifies :run, "execute[st2-systemctl-daemon-reload]"
    end
  end

  service "st2actionrunner-#{n}" do
    provider Chef::Provider::Service.const_get(service_provider.to_s.capitalize)
    action :enable
  end
end

# Create master for action runners
service 'st2actionrunner' do
  provider Chef::Provider::Service.const_get(service_provider.to_s.capitalize)
  action [ :enable, :start ]
end
