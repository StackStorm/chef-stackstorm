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
