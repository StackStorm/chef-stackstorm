# # encoding: utf-8

# Inspec test for recipe stackstorm::_services

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

# List of available `st2` services:
# https://github.com/StackStorm/st2/blob/master/st2common/bin/st2ctl#L5
ST2_SERVICES = %w(
  st2actionrunner st2api st2stream
  st2auth st2garbagecollector st2notifier
  st2resultstracker st2rulesengine st2sensorcontainer
  st2timersengine st2workflowengine st2scheduler
).freeze

ST2_SERVICES.each do |service_name|
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end
