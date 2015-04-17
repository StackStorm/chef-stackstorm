include_recipe "python::#{node['python']['install_method']}"

if platform_family?('rhel', 'fedora')
  include_recipe('yum-epel') if platform_family?('rhel')

  package('python-pip') do
    action :install
  end
end

include_recipe "python::pip"
include_recipe "python::virtualenv"
