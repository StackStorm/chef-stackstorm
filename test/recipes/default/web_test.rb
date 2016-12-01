# # encoding: utf-8

# Inspec test for recipe stackstorm::web

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package 'st2web' do
  it { should be_installed }
end

describe package 'nginx' do
  it { should be_installed }
end

describe directory('/etc/ssl/st2') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

# 'nginx' listens on port 80
describe port(80) do
  it { should be_listening }
end

# 'nginx' listens on port 443
describe port(443) do
  it { should be_listening }
end

# 'st2web' listens on port 443
describe port(9100) do
  it { should be_listening }
end
