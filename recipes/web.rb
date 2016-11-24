package 'st2web'

node.default['nginx']['default_site_enabled'] = false

# Ensure directory for Nginx SSL certificates is available
directory '/etc/ssl/st2' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

openssl_x509 '/etc/ssl/st2/st2.crt' do
  common_name node.name
  org 'StackStorm'
  org_unit 'Information Technology'
  country 'US'
end

include_recipe 'chef_nginx::repo'
include_recipe 'chef_nginx::default'

nginx_site 'st2.conf' do
  template 'nginx/st2.conf.erb'
  cookbook 'stackstorm'
  action :enable
end
