# # encoding: utf-8

# Inspec test for recipe stackstorm::_packages

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package 'st2' do
  it { should be_installed }
end
