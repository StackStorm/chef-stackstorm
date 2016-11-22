#
# Cookbook Name:: stackstorm
# Recipe:: _services
#
# Copyright (C) 2016 StackStorm (info@stackstorm.com)
#

# Enable & Start st2 services
node['stackstorm']['SERVICES'].each do |service_name|
  service service_name do
    action [:enable, :start]
    supports status: true, start: true, stop: true, restart: true
    subscribes :restart, 'template[:create StackStorm configuration]', :delayed
  end
end
