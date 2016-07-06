require 'spec_helper'

describe 'stackstorm::default' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe stackstorm::_initial' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_initial')
      chef_run
    end

    it 'should include recipe stackstorm::_packages' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_packages')
      chef_run
    end

    it 'should include recipe stackstorm::config' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::config')
      chef_run
    end
  end
end
