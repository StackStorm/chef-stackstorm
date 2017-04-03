#
# Cookbook Name:: stackstorm
# Recipe:: mistral
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

node.override['openstack-mistral']['etc_dir'] = '/etc/mistral'
node.override['openstack-mistral']['db_initialize']['enabled'] = true
node.override['openstack-mistral']['db_initialize']['password'] = 'ilikerandompasswords'

include_recipe 'rabbitmq::default'
include_recipe 'openstack-mistral'
include_recipe 'openstack-mistral::_database'
