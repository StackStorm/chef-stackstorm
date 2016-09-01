include_recipe 'apt'

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

# Fix localhost in hosts
hostsfile_entry '127.0.0.1' do
  hostname 'localhost'
  comment 'Appended by st2 cookbook'
  action :append
  only_if { platform_family?('rhel') }
end
