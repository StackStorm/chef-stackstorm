require 'spec_helper'

describe 'stackstorm::mistral' do
  before do
    global_stubs_include_recipe
  end

  platforms = {
    'ubuntu' => ['14.04'],
    'centos' => ['7.0']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "Using #{platform} #{version} with default node attributes" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

        it 'should include recipe openstack-mistral' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral')
          chef_run
        end

        it 'should include recipe rabbitmq' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rabbitmq::default')
          chef_run
        end

        it 'should include recipe openstack-mistral::_database' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openstack-mistral::_database')
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
  end
end
