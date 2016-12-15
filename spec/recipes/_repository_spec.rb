require 'spec_helper'

describe 'stackstorm::_repository' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    let(:execute) { chef_run.execute('Ubuntu Precise and Trusty: APT hash sum mismatch workaround') }

    it 'should include recipe apt' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt')
      chef_run
    end

    it 'should create packagecloud_repo "StackStorm/stable"' do
      expect(chef_run).to create_packagecloud_repo('StackStorm/stable').with(
        type: 'deb'
      )
    end

    it 'should not install pacakge "apt"' do
      expect(chef_run).to_not install_package('apt').with(version: '1.2.10')
    end

    it 'runs a execute "Ubuntu Precise and Trusty: APT hash sum mismatch workaround"' do
      expect(chef_run).to run_execute('curl -s https://packagecloud.io/install/repositories/computology/apt-backport/script.deb.sh | bash')
    end

    it 'sends the notification to the apt resource immediately' do
      expect(execute).to notify('package[apt]').to(:install).immediately
    end
  end
end
