require 'spec_helper'

describe 'stackstorm::_repository' do
  before do
    global_stubs_include_recipe
  end

  let(:chef_run_ubuntu_1404) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }
  let(:chef_run_centos_7) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7.5.1804').converge(described_recipe) }

  platforms = {
    'ubuntu' => ['14.04'],
    'centos' => ['7.5.1804'],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "Using #{platform} #{version} with default node attributes" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

        it 'should include recipe apt' do
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
          chef_run
        end
      end
    end
  end

  context 'Using ubuntu 14.04 with default node attributes' do
    let(:chef_run) { chef_run_ubuntu_1404 }

    it 'should create packagecloud_repo "StackStorm/stable"' do
      expect(chef_run_ubuntu_1404).to create_packagecloud_repo('StackStorm/stable').with(
        type: 'deb'
      )
    end
  end

  context 'Using centos 7.0 with default node attributes' do
    let(:execute) { chef_run_centos_7 }

    it 'should create packagecloud_repo "StackStorm/stable"' do
      expect(chef_run_centos_7).to create_packagecloud_repo('StackStorm/stable').with(
        type: 'rpm'
      )
    end
  end
end
