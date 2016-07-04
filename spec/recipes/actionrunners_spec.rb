require 'spec_helper'

describe 'stackstorm::actionrunners' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should enable service "actionrunners enable and start StackStorm service st2actionrunner"' do
      expect(chef_run).to_not enable_service('actionrunners enable and start StackStorm service st2actionrunner').with(
        service_name: 'st2actionrunner'
      )
    end

    it 'should start service "actionrunners enable and start StackStorm service st2actionrunner"' do
      expect(chef_run).to_not start_service('actionrunners enable and start StackStorm service st2actionrunner').with(
        service_name: 'st2actionrunner'
      )
    end
  end

  context "with node['stackstorm']['roles'] = ['worker']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['stackstorm']['roles'] = %w(worker)
      end.converge(described_recipe)
    end

    it 'should override "node[\'stackstorm\'][\'components\']"' do
      expect(chef_run.node['stackstorm']['components']).to eq(
        %w(
          st2common
          st2actions
        )
      )
    end

    it 'should include recipe stackstorm::_packages' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_packages')
      chef_run
    end

    it 'should include recipe stackstorm::config' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::config')
      chef_run
    end

    it 'should enable service "actionrunners enable and start StackStorm service st2actionrunner"' do
      expect(chef_run).to enable_service('actionrunners enable and start StackStorm service st2actionrunner').with(
        service_name: 'st2actionrunner'
      )
    end

    it 'should start service "actionrunners enable and start StackStorm service st2actionrunner"' do
      expect(chef_run).to start_service('actionrunners enable and start StackStorm service st2actionrunner').with(
        service_name: 'st2actionrunner'
      )
    end
  end
end
