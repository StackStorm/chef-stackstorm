# # encoding: utf-8

# Inspec test for recipe stackstorm::web

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package('st2web') do
  it { should be_installed }
end

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# nginx version should be >= '1.7.5'
# TODO: Custom matcher/resource to identify and semver compare installed package version
# See: https://docs.stackstorm.com/install/deb.html#install-webui-and-setup-ssl-termination

describe directory('/etc/ssl/st2') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

describe file('/etc/ssl/st2/st2.crt') do
  it { should exist }
end

describe file('/etc/ssl/st2/st2.key') do
  it { should exist }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe file('/etc/nginx/sites-enabled/default') do
  it { should_not exist }
end

describe file('/etc/nginx/sites-enabled/st2.conf') do
  it { should exist }
  it { should be_symlink }
  it { should be_linked_to '/etc/nginx/sites-available/st2.conf' }
end

# TODO: Test REST API endpoints, defined in nginx
# Ex: http://stackoverflow.com/a/6326763/4533625
