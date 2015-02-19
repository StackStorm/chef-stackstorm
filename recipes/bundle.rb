#
# Cookbook Name:: stackstorm
# Recipe:: bundle
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# StackStorm "all in one" recipe deploys st2 roles as well as dependant
# services which are mongodb, rabbitmq and mysql (used by mistral).
#

node.override['stackstorm']['roles'] = %w(controller worker client)

include_recipe 'stackstorm::_initial'
include_recipe 'stackstorm::_mongodb'
include_recipe 'rabbitmq::default'
include_recipe 'stackstorm::default'
include_recipe 'stackstorm::mistral'
