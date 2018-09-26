#
# Cookbook Name:: stackstorm
# Recipe:: _repository
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'apt'

type = case node['platform_family']
       when 'rhel'
         'rpm'
       else
         'deb'
       end

packagecloud_repo 'StackStorm/stable' do
  type type
end
