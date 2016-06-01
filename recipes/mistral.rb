#
# Cookbook Name:: stackstorm
# Recipe:: mistral
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

mysql_service 'default' do
  port '3306'
  initial_root_password 'ilikerandompasswords'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

node.override['openstack-mistral']['etc_dir'] = '/etc/mistral'
node.override['openstack-mistral']['source']['git_url'] = 'https://github.com/StackStorm/mistral.git'
node.override['openstack-mistral']['source']['git_revision'] = 'st2-0.9.0'
node.override['openstack-mistral']['db_initialize']['enabled'] = true
node.override['openstack-mistral']['db_initialize']['password'] = 'ilikerandompasswords'

mistral 'default' do
  action [:create, :start]
  options(
    database: {
      # Use tcp since socket connections might fail, in case right socket
      # can't be located.
      connection: 'mysql://mistral:StackStorm@127.0.0.1/mistral'
    }
  )
end
