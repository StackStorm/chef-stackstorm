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
node.override['openstack-mistral']['source']['git_revision'] = 'st2-0.8.1'
node.override['openstack-mistral']['db_initialize']['enabled'] = true
node.override['openstack-mistral']['db_initialize']['password'] = 'ilikerandompasswords'

mistral 'default' do
  action [ :create, :start ]
  options({
    database: {
      # Use tcp since socket connections might fail, in case right socket
      # can't be located.
      connection: 'mysql://mistral:StackStorm@127.0.0.1/mistral'
    }
  })
end

# st2mistral plugin installation
mistral_rev = node['openstack-mistral']['source']['git_revision']

git "fetch https://github.com/StackStorm/st2mistral.git" do
  destination '/etc/mistral/actions'
  repository "https://github.com/StackStorm/st2mistral.git"
  revision mistral_rev
  action(node['openstack-mistral']['source']['git_action'] || :checkout)
  notifies :run, "execute[:run st2mistral plugin setup]"
end

python_pip ":install python-mistralclient" do
  package_name "git+https://github.com/StackStorm/python-mistralclient.git@#{mistral_rev}"
  virtualenv " #{node['openstack-mistral']['source']['home']}/.venv"
  action :install
end

execute ":run st2mistral plugin setup" do
  cwd '/etc/mistral/actions'
  command "sh -c '. #{node['openstack-mistral']['source']['home']}/.venv/bin/activate; python setup.py develop'"
  action :nothing
end
