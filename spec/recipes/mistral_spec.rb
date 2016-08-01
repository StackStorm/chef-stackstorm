require 'spec_helper'

describe 'stackstorm::mistral' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe openstack-mistral' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral')
      chef_run
    end

    it 'should include recipe rabbitmq' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rabbitmq')
      chef_run
    end

    it 'should include recipe openstack-mistral::_database' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral::_database')
      chef_run
    end

    it 'should override "node[\'openstack-mistral\'][\'etc_dir\']"' do
      expect(chef_run.node['openstack-mistral']['etc_dir']).to eq('/etc/mistral')
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'enabled\']"' do
      expect(chef_run.node['openstack-mistral']['db_initialize']['enabled']).to eq(true)
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'password\']"' do
      expect(chef_run.node['openstack-mistral']['db_initialize']['password']).to eq('ilikerandompasswords')
    end
  end
end
