require 'spec_helper'

describe 'stackstorm::default' do
  before do
    global_stubs_include_recipe
  end

  let(:chef_run_ubuntu_1404) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }
  let(:chef_run_centos_7) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0').converge(described_recipe) }

  context 'using ubuntu 14.04 with default node attributes' do
    it 'should include recipe stackstorm::_repository' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_repository')
      chef_run_ubuntu_1404
    end

    it 'should install pacakge "st2"' do
      expect(chef_run).to install_package('st2')
    end

    it 'should include recipe stackstorm::config' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::config')
      chef_run_ubuntu_1404
    end

    it 'should include recipe stackstorm::_services' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_services')
      chef_run_ubuntu_1404
    end

    it 'should generate htpasswd file with auth credentials' do
      expect(chef_run_ubuntu_1404).to add_htpasswd(':add credentials to htpasswd file').with(
        file: '/etc/st2/htpasswd',
        user: 'st2admin',
        password: 'Ch@ngeMe'
      )
    end
  end

  context 'using centos 7 with default node attributes' do
    it 'should include recipe stackstorm::_packages' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_packages')
      chef_run_centos_7
    end

    it 'should include recipe stackstorm::config' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::config')
      chef_run_centos_7
    end

    it 'should include recipe stackstorm::_services' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_services')
      chef_run_centos_7
    end

    it 'should generate htpasswd file with auth credentials' do
      expect(chef_run_centos_7).to add_htpasswd(':add credentials to htpasswd file').with(
        file: '/etc/st2/htpasswd',
        user: 'st2admin',
        password: 'Ch@ngeMe'
      )
    end
  end
end
