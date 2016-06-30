#
# Cookbook Name:: stackstorm
# Recipe:: actionrunners
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Recipe brings up StackStorm action runner system services.
#

send :extend, StackstormCookbook::RecipeHelpers
return unless apply_components.include?('st2actions')
include_recipe 'stackstorm::_packages'
include_recipe 'stackstorm::config'

# TODO: support customizable WORKER, default to 10 (set by package)
# export WORKERS
service "#{recipe_name} enable and start StackStorm service st2actionrunner" do
  service_name 'st2actionrunner'
  action [:enable, :start]
end
