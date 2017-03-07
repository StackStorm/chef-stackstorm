# # encoding: utf-8

# Inspec test for recipe stackstorm::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package 'st2' do
  it { should be_installed }
end

describe file('/etc/st2/htpasswd') do
  it { should exist }
  its('owner') { should eq 'st2' }
  its('group') { should eq 'st2' }
  it { should be_readable.by('owner') }
  it { should be_writable.by('owner') }
  it { should_not be_readable.by('group') }
  it { should_not be_writable.by('group') }
  it { should_not be_executable.by('owner') }
  it { should_not be_executable.by('group') }
end
