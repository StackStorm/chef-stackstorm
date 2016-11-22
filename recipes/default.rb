#
# Cookbook Name:: stackstorm
# Recipe:: default
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#
include_recipe 'stackstorm::_packages'
include_recipe 'stackstorm::user'
include_recipe 'stackstorm::config'
include_recipe 'stackstorm::_services'
