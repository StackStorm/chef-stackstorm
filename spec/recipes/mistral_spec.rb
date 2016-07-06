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

    it 'should create mysql_service "default"' do
      expect(chef_run).to create_mysql_service('default').with(
        port: '3306',
        initial_root_password: 'ilikerandompasswords'
      )
    end

    it 'should start mysql_service "default"' do
      expect(chef_run).to start_mysql_service('default').with(
        port: '3306',
        initial_root_password: 'ilikerandompasswords'
      )
    end

    it 'should create mysql_client "default"' do
      expect(chef_run).to create_mysql_client('default')
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

    it 'should create mistral "default"' do
      skip('openstack-mistral cookbook is missing chefspec matchers')
      expect(chef_run).to create_mistral('default').with(
        options: {
          database: {
            connection: 'mysql://mistral:StackStorm@127.0.0.1/mistral'
          }
        }
      )
    end

    it 'should start mistral "default"' do
      skip('openstack-mistral cookbook is missing chefspec matchers')
      expect(chef_run).to start_mistral('default').with(
        options: {
          database: {
            connection: 'mysql://mistral:StackStorm@127.0.0.1/mistral'
          }
        }
      )
    end
  end
end
