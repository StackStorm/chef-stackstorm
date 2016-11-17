require 'spec_helper'

describe 'stackstorm::_packages' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'should create packagecloud_repo "StackStorm/stable"' do
      expect(chef_run).to create_packagecloud_repo('StackStorm/stable').with(
        type: 'deb'
      )
    end

    it 'should install pacakge "st2"' do
      expect(chef_run).to install_package('st2')
    end
  end
end
