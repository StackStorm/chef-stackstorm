require 'spec_helper'

describe 'stackstorm::default' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe stackstorm::_repository' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_repository')
      chef_run
    end

    it 'should install pacakge "st2"' do
      expect(chef_run).to install_package('st2')
    end

    it 'should include recipe stackstorm::config' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::config')
      chef_run
    end

    it 'should include recipe stackstorm::_services' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_services')
      chef_run
    end

    it 'should generate htpasswd file with auth credentials' do
      expect(chef_run).to add_htpasswd(':add credentials to htpasswd file').with(
        file: '/etc/st2/htpasswd',
        user: 'st2admin',
        password: 'Ch@ngeMe'
      )
    end
  end
end
