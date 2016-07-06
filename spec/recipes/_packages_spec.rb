require 'spec_helper'

describe 'stackstorm::_packages' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe stackstorm::_initial' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_initial')
      chef_run
    end

    it 'should override "node[\'stackstorm\'][\'bin_dir\']"' do
      expect(chef_run.node['stackstorm']['bin_dir']).to eq('/usr/bin')
    end

    it 'should override "node[\'stackstorm\'][\'python_binary\']"' do
      expect(chef_run.node['stackstorm']['python_binary']).to eq('/usr/bin/python')
    end

    it 'should create packagecloud_repo "StackStorm/stable"' do
      expect(chef_run).to create_packagecloud_repo('StackStorm/stable').with(
        type: 'rpm'
      )
    end

    it 'should install pacakge "st2"' do
      expect(chef_run).to install_package('st2')
    end

    it 'should install pacakge "st2mistral"' do
      expect(chef_run).to install_package('st2mistral')
    end

    it 'should not install pacakge "st2debug"' do
      expect(chef_run).to_not install_package('st2debug')
    end

    it 'should override "node[\'stackstorm\'][\'components\']"' do
      expect(chef_run.node['stackstorm']['components']).to eq(
        %w(
          st2common
        )
      )
    end

    it 'should include recipe stackstorm::actionrunners' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::actionrunners')
      chef_run
    end
  end

  context "with node['stackstorm']['install_repo']['debug_package'] = true" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['stackstorm']['install_repo']['debug_package'] = true
      end.converge(described_recipe)
    end

    it 'should install pacakge "st2debug"' do
      expect(chef_run).to install_package('st2debug')
    end
  end

  context "with node['stackstorm']['roles'] = ['controller']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['stackstorm']['roles'] = %w(controller)
      end.converge(described_recipe)
    end

    it 'should override "node[\'stackstorm\'][\'components\']"' do
      expect(chef_run.node['stackstorm']['components']).to eq(
        %w(
          st2common
          st2api
          st2reactor
          st2auth
        )
      )
    end

    it 'should enable service "_packages enable and start StackStorm service st2api"' do
      expect(chef_run).to enable_service('_packages enable and start StackStorm service st2api').with(
        service_name: 'st2api'
      )
    end

    it 'should start service "_packages enable and start StackStorm service st2api"' do
      expect(chef_run).to start_service('_packages enable and start StackStorm service st2api').with(
        service_name: 'st2api'
      )
    end

    it 'should enable service "_packages enable and start StackStorm service st2rulesengine"' do
      expect(chef_run).to enable_service('_packages enable and start StackStorm service st2rulesengine').with(
        service_name: 'st2rulesengine'
      )
    end

    it 'should start service "_packages enable and start StackStorm service st2rulesengine"' do
      expect(chef_run).to start_service('_packages enable and start StackStorm service st2rulesengine').with(
        service_name: 'st2rulesengine'
      )
    end

    it 'should enable service "_packages enable and start StackStorm service st2sensorcontainer"' do
      expect(chef_run).to enable_service('_packages enable and start StackStorm service st2sensorcontainer').with(
        service_name: 'st2sensorcontainer'
      )
    end

    it 'should start service "_packages enable and start StackStorm service st2sensorcontainer"' do
      expect(chef_run).to start_service('_packages enable and start StackStorm service st2sensorcontainer').with(
        service_name: 'st2sensorcontainer'
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

    it 'should enable service "_packages enable and start StackStorm service st2resultstracker"' do
      expect(chef_run).to enable_service('_packages enable and start StackStorm service st2resultstracker').with(
        service_name: 'st2resultstracker'
      )
    end

    it 'should start service "_packages enable and start StackStorm service st2resultstracker"' do
      expect(chef_run).to start_service('_packages enable and start StackStorm service st2resultstracker').with(
        service_name: 'st2resultstracker'
      )
    end

    it 'should enable service "_packages enable and start StackStorm service st2notifier"' do
      expect(chef_run).to enable_service('_packages enable and start StackStorm service st2notifier').with(
        service_name: 'st2notifier'
      )
    end

    it 'should start service "_packages enable and start StackStorm service st2notifier"' do
      expect(chef_run).to start_service('_packages enable and start StackStorm service st2notifier').with(
        service_name: 'st2notifier'
      )
    end
  end

  context "with node['stackstorm']['roles'] = ['client']" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['stackstorm']['roles'] = %w(client)
      end.converge(described_recipe)
    end

    it 'should override "node[\'stackstorm\'][\'components\']"' do
      expect(chef_run.node['stackstorm']['components']).to eq(
        %w(
          st2common
          st2client
        )
      )
    end
  end
end
