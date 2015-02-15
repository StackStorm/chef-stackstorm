#
# Cookbook Name:: stackstorm
# Recipe:: default
#
# Copyright (C) 2015 StackStorm (info@stackstorm.com)
#

include_recipe 'build-essential::default'
include_recipe 'stackstorm::_python'
include_recipe 'git::default'
include_recipe 'stackstorm::user'

[
  node['stackstorm']['home'],
  node['stackstorm']['etc_dir']
].each do |path|
  directory "creating st2 directory #{path}" do
    path path
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

# Create default user and group to run unprivileged StackStorm services.
user 'st2' do
  home '/home/st2'
  supports manage_home: true
  action :create
end

directory "creating st2 log directory" do
  path node['stackstorm']['log_dir']
  owner node['stackstorm']['runas_user']
  group node['stackstorm']['runas_group']
  mode '0755'
  action :create
end

case node['stackstorm']['install_method'].to_sym
when :system_wide
  stackstorm_install 'st2common' do
    packages %w[ st2common ]
    action :install
  end

  remote_file "#{node['stackstorm']['etc_dir']}/st2-requirements.txt" do
    source 'https://raw.githubusercontent.com/StackStorm/st2/master/requirements.txt'
    mode '0644'
  end

  python_pip "install St2 requirements.txt system-wide" do
    package_name "#{node['stackstorm']['etc_dir']}/st2-requirements.txt"
    options '-r'
    action  :install
  end
end

# Backup original st2.conf
file "#{node['stackstorm'][:etc_dir]}/st2.conf.dist" do
  content lazy { ::IO.read("#{node['stackstorm'][:etc_dir]}/st2.conf") }
  not_if { ::File.exist?("#{node['stackstorm'][:etc_dir]}/st2.conf.dist") }
  only_if { ::File.exist?("#{node['stackstorm'][:etc_dir]}/st2.conf") }
end

template "#{node['stackstorm'][:etc_dir]}/st2.conf" do
  owner 'root' and group 'root'
  mode 0644
  source 'st2.conf.erb'
  variables lazy { {config: node['stackstorm']['config']} }
  action :create
end

execute "st2-systemctl-daemon-reload" do
  command 'systemctl daemon-reload'
  action :nothing
end
