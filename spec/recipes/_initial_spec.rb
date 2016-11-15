require 'spec_helper'

describe 'stackstorm::_initial' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'should create directory "/opt/stackstorm"' do
      expect(chef_run).to create_directory('/opt/stackstorm').with(
        owner: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'should create directory "/etc/st2"' do
      expect(chef_run).to create_directory('/etc/st2').with(
        owner: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'should create user "st2"' do
      expect(chef_run).to create_user('st2').with(
        home: '/home/st2',
        supports: {
          manage_home: true
        }
      )
    end
  end
end
