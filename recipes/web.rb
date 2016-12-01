package 'st2web'

node.default['nginx']['default_site_enabled'] = false

# Ensure directory for Nginx SSL certificates is available
directory '/etc/ssl/st2' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Self-signed certificate
openssl_x509 '/etc/ssl/st2/st2.crt' do
  common_name node.name
  org node['stackstorm']['ssl']['self_signed']['org']
  org_unit node['stackstorm']['ssl']['self_signed']['org_unit']
  country node['stackstorm']['ssl']['self_signed']['country']
  only_if { node['stackstorm']['ssl']['self_signed']['enabled'] == true }
end

include_recipe 'chef_nginx::repo'
include_recipe 'chef_nginx::default'

nginx_site 'st2.conf' do
  template 'nginx/st2.conf.erb'
  cookbook 'stackstorm'
  action :enable
end
