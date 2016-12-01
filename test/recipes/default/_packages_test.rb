# # encoding: utf-8

# Inspec test for recipe stackstorm::_packages

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package 'st2' do
  it { should be_installed }
end

if os[:family] == 'debian'
  describe file '/etc/apt/sources.list.d/StackStorm_stable.list' do
    it { should exist }
  end
elsif os[:family] == 'redhat'
  describe file '/etc/yum.repos.d/StackStorm_stable.repo' do
    it { should exist }
  end
  describe yum.repo 'StackStorm_stable' do
    it { should exist }
    it { should be_enabled }
  end
end
