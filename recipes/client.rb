#
# Cookbook Name:: stackstorm
# Recipe:: client
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

# Client recipe. Installs st2 cli binary.
#

include_recipe 'stackstorm::default'

case node['stackstorm']['install_method'].to_sym
when :system_wide

  stackstorm_install 'st2client' do
    packages %w(st2client)
    action :install
  end

  remote_file "#{node['stackstorm']['etc_dir']}/st2client-requirements.txt" do
    source 'https://raw.githubusercontent.com/StackStorm/st2/master/st2client/requirements.txt'
    mode '0644'
  end

  python_pip "install St2 client requirements.txt system-wide" do
    package_name "-r #{node['stackstorm']['etc_dir']}/st2client-requirements.txt"
    action  :install
  end

end
