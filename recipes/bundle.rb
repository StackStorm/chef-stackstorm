#
# Cookbook Name:: stackstorm
# Recipe:: bundle
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# StackStorm "all in one" recipe deploys st2 roles as well as dependant
# services which are mongodb, rabbitmq and mysql (used by mistral).
#

include_recipe 'build-essential::default'
include_recipe 'stackstorm::_python'
include_recipe 'git::default'
include_recipe 'rabbitmq::default'
include_recipe 'stackstorm::_mongodb'
include_recipe 'stackstorm::controller'
# include_recipe 'stackstorm::worker'
# include_recipe 'stackstorm::client'
