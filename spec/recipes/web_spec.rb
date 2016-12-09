require 'spec_helper'

describe 'stackstorm::web' do
  before do
    global_stubs_include_recipe
  end

  platforms = {
    'ubuntu' => ['14.04'],
    'centos' => ['7.0']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

      context "Using #{platform} #{version} with default node attributes" do
        it 'should install pacakge "st2web"' do
          expect(chef_run).to install_package('st2web')
        end

        it 'should create /etc/ssl/st2 directory with attributes' do
          expect(chef_run).to create_directory('/etc/ssl/st2').with(
            user: 'root',
            group: 'root',
            mode: '0755'
          )
        end

        it 'should create a self-signed certificate "/etc/ssl/st2/st2.crt"' do
          expect(chef_run).to create_x509_certificate('/etc/ssl/st2/st2.crt')
        end

        it 'should include recipe chef_nginx::repo' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::repo')
          chef_run
        end

        it 'should include recipe chef_nginx::default' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('chef_nginx::default')
          chef_run
        end

        it 'should enable "st2.conf" nginx site"' do
          expect(chef_run).to enable_nginx_site('st2.conf')
        end
      end
    end
  end
end
