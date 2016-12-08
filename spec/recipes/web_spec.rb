require 'spec_helper'

describe 'stackstorm::web' do
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

    it 'should install pacakge "st2web"' do
      expect(chef_run_ubuntu_1404).to install_package('st2web')
    end

    it 'should create /etc/ssl/st2 directory with attributes' do
      expect(chef_run_ubuntu_1404).to create_directory('/etc/ssl/st2').with(
        user: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'should create a self-signed certificate "/etc/ssl/st2/st2.crt"' do
      expect(chef_run_ubuntu_1404).to create_x509_certificate('/etc/ssl/st2/st2.crt')
    end

    it 'should include recipe chef_nginx::repo' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::repo')
      chef_run_ubuntu_1404
    end

    it 'should include recipe chef_nginx::default' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::default')
      chef_run_ubuntu_1404
    end

    it 'should enable "st2.conf" nginx site"' do
      expect(chef_run_ubuntu_1404).to enable_nginx_site('st2.conf')
    end
  end

  context 'using centos 7 with default node attributes' do
    it 'should include recipe stackstorm::_repository' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::_repository')
      chef_run_centos_7
    end

    it 'should install pacakge "st2web"' do
      expect(chef_run_centos_7).to install_package('st2web')
    end

    it 'should create /etc/ssl/st2 directory with attributes' do
      expect(chef_run_centos_7).to create_directory('/etc/ssl/st2').with(
        user: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'should create a self-signed certificate "/etc/ssl/st2/st2.crt"' do
      expect(chef_run_centos_7).to create_x509_certificate('/etc/ssl/st2/st2.crt')
    end

    it 'should include recipe chef_nginx::repo' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::repo')
      chef_run_centos_7
    end

    it 'should include recipe chef_nginx::default' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::default')
      chef_run_centos_7
    end

    it 'should enable "st2.conf" nginx site"' do
      expect(chef_run_centos_7).to enable_nginx_site('st2.conf')
    end
  end
end
