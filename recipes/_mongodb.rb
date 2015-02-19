# Mongodb cookbook overridings.

node.override['mongodb']['install_method'] = 'distro'
node.override['mongodb']['package_name']   = 'mongodb-server'
node.override['mongodb']['user'] = 'mongodb'
node.override['mongodb']['group'] = 'mongodb'
node.override['mongodb']['sysconfig']['DAEMONUSER'] = node['mongodb']['user']
node.override['mongodb']['sysconfig']['DAEMON_USER'] = node['mongodb']['user']

include_recipe 'mongodb::install'

# Remove conflicting configuration of systemd services, since they don't
# start properly with the configuration provided by mongodb cookbook.
if %w(rhel fedora).include?(node['platform_family'])
  %w(s d).each do |letter|
    service "st2 remove systemd mongo#{letter} service" do
      service_name "mongo#{letter}"
      provider Chef::Provider::Service::Systemd
      action [ :stop, :disable ]
      only_if { ::File.exist?("/lib/systemd/system/mongo#{letter}.service") }
    end

    file("/lib/systemd/system/mongo#{letter}.service") do
      action :delete
      notifies :run, 'execute[st2-systemctl-daemon-reload]'      
    end
  end

  execute 'st2-systemctl-daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end

mongodb_instance node['mongodb']['instance_name'] do
  mongodb_type 'mongod'
  bind_ip      node['mongodb']['config']['bind_ip']
  port         node['mongodb']['config']['port']
  logpath      node['mongodb']['config']['logpath']
  dbpath       node['mongodb']['config']['dbpath']
  enable_rest  node['mongodb']['config']['rest']
  smallfiles   node['mongodb']['config']['smallfiles']
end
