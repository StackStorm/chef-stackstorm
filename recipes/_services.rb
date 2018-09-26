#
# Cookbook Name:: stackstorm
# Recipe:: _services
#
# Copyright (C) 2016 StackStorm (info@stackstorm.com)
#

# List of available `st2` services:
# https://github.com/StackStorm/st2/blob/master/st2common/bin/st2ctl#L5
ST2_SERVICES = %w(
  st2actionrunner st2api st2stream
  st2auth st2garbagecollector st2notifier
  st2resultstracker st2rulesengine st2sensorcontainer
  st2timersengine st2workflowengine
).freeze

# Enable & Start st2 services
ST2_SERVICES.each do |service_name|
  service service_name do
    action [:enable, :start]
    supports status: true, start: true, stop: true, restart: true
    subscribes :restart, 'template[:create StackStorm configuration]', :delayed
  end
end
