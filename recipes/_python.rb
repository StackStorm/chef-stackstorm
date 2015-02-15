include_recipe "python::#{node['python']['install_method']}"

if platform_family?("rhel", "fedora")
  # st2* packages depend on python-pip from epel, so we work it around.
  # Though packages should not strictly depened like this!
  include_recipe 'yum-epel::default'

  package('python-pip') do
    action :install
  end
end

include_recipe "python::pip"
include_recipe "python::virtualenv"
