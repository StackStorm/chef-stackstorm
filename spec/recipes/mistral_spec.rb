require 'spec_helper'

describe 'stackstorm::mistral' do
  before do
    global_stubs_include_recipe
  end

  let(:chef_run_ubuntu_1404) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }
  let(:chef_run_centos_7) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0').converge(described_recipe) }

  context 'using ubuntu 14.04 with default node attributes' do
    it 'should include recipe openstack-mistral' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral')
      chef_run_ubuntu_1404
    end

    it 'should include recipe rabbitmq' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rabbitmq::default')
      chef_run_ubuntu_1404
    end

    it 'should include recipe openstack-mistral::_database' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral::_database')
      chef_run_ubuntu_1404
    end

    it 'should override "node[\'openstack-mistral\'][\'etc_dir\']"' do
      expect(chef_run_ubuntu_1404.node['openstack-mistral']['etc_dir']).to eq('/etc/mistral')
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'enabled\']"' do
      expect(chef_run_ubuntu_1404.node['openstack-mistral']['db_initialize']['enabled']).to eq(true)
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'password\']"' do
      expect(chef_run_ubuntu_1404.node['openstack-mistral']['db_initialize']['password']).to eq('ilikerandompasswords')
    end
  end

  context 'using centos 7 with default node attributes' do
    it 'should include recipe openstack-mistral' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral')
      chef_run_centos_7
    end

    it 'should include recipe rabbitmq' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rabbitmq::default')
      chef_run_centos_7
    end

    it 'should include recipe openstack-mistral::_database' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral::_database')
      chef_run_centos_7
    end

    it 'should override "node[\'openstack-mistral\'][\'etc_dir\']"' do
      expect(chef_run_centos_7.node['openstack-mistral']['etc_dir']).to eq('/etc/mistral')
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'enabled\']"' do
      expect(chef_run_centos_7.node['openstack-mistral']['db_initialize']['enabled']).to eq(true)
    end

    it 'should override "node[\'openstack-mistral\'][\'db_initialize\'][\'password\']"' do
      expect(chef_run_centos_7.node['openstack-mistral']['db_initialize']['password']).to eq('ilikerandompasswords')
    end
  end
end
