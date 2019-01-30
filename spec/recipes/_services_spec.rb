require 'spec_helper'

# List of available `st2` services:
# https://github.com/StackStorm/st2/blob/master/st2common/bin/st2ctl#L5
ST2_SERVICES = %w(
  st2actionrunner st2api st2stream
  st2auth st2garbagecollector st2notifier
  st2resultstracker st2rulesengine st2sensorcontainer
  st2timersengine st2workflowengine st2scheduler
).freeze

describe 'stackstorm::_services' do
  before do
    global_stubs_include_recipe
  end

  platforms = {
    'ubuntu' => ['14.04'],
    'centos' => ['7.5'],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "Using #{platform} #{version} with default node attributes" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

        ST2_SERVICES.each do |service_name|
          it "should enable and start service '#{service_name}'" do
            expect(chef_run).to enable_service(service_name)
            expect(chef_run).to start_service(service_name)
          end
        end
      end
    end
  end
end
