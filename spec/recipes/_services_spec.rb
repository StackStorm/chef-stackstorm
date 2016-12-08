require 'spec_helper'

# List of available `st2` services:
# https://github.com/StackStorm/st2/blob/master/st2common/bin/st2ctl#L5
ST2_SERVICES = %w(
  st2actionrunner st2api st2stream
  st2auth st2garbagecollector st2notifier
  st2resultstracker st2rulesengine st2sensorcontainer
).freeze

describe 'stackstorm::_services' do
  before do
    global_stubs_include_recipe
  end

  let(:chef_run_ubuntu_1404) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }
  let(:chef_run_centos_7) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0').converge(described_recipe) }

  context 'using ubuntu 14.04 with default node attributes' do
    ST2_SERVICES.each do |service_name|
      it "should enable and start service '#{service_name}'" do
        expect(chef_run_ubuntu_1404).to enable_service(service_name)
        expect(chef_run_ubuntu_1404).to start_service(service_name)
      end
    end
  end

  context 'using centos 7 with default node attributes' do
    ST2_SERVICES.each do |service_name|
      it "should enable and start service '#{service_name}'" do
        expect(chef_run_centos_7).to enable_service(service_name)
        expect(chef_run_centos_7).to start_service(service_name)
      end
    end
  end
end
