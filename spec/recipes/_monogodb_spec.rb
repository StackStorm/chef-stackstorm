require 'spec_helper'

describe 'stackstorm::_mongodb' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'should override "node[\'mongodb\'][\'install_method\']"' do
      expect(chef_run.node['mongodb']['install_method']).to eq('distro')
    end

    it 'should override "node[\'mongodb\'][\'package_name\']"' do
      expect(chef_run.node['mongodb']['package_name']).to eq('mongodb-server')
    end

    it 'should override "node[\'mongodb\'][\'user\']"' do
      expect(chef_run.node['mongodb']['user']).to eq('mongodb')
    end

    it 'should override "node[\'mongodb\'][\'group\']"' do
      expect(chef_run.node['mongodb']['group']).to eq('mongodb')
    end

    it 'should override "node[\'mongodb\'][\'sysconfig\'][\'DAEMONUSER\']"' do
      expect(chef_run.node['mongodb']['sysconfig']['DAEMONUSER']).to eq('mongodb')
    end

    it 'should override "node[\'mongodb\'][\'sysconfig\'][\'DAEMON_USER\']"' do
      expect(chef_run.node['mongodb']['sysconfig']['DAEMON_USER']).to eq('mongodb')
    end

    it 'should include recipe mongodb::install' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('mongodb::install')
      chef_run
    end

    it 'should stop service "mongos"' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/lib/systemd/system/mongos.service').and_return(true)
      expect(chef_run).to stop_service('st2 remove systemd mongos service').with(
        service_name: 'mongos',
        provider: Chef::Provider::Service::Systemd
      )
    end

    it 'should disable service "mongos"' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/lib/systemd/system/mongos.service').and_return(true)
      expect(chef_run).to disable_service('st2 remove systemd mongos service').with(
        service_name: 'mongos',
        provider: Chef::Provider::Service::Systemd
      )
    end

    it 'should delete file "mongos"' do
      expect(chef_run).to delete_file('/lib/systemd/system/mongos.service')
      resource = chef_run.file('/lib/systemd/system/mongos.service')
      expect(resource).to notify('execute[st2-systemctl-daemon-reload]').to(:run).delayed
    end

    it 'should stop service "mongod"' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/lib/systemd/system/mongod.service').and_return(true)
      expect(chef_run).to stop_service('st2 remove systemd mongod service').with(
        service_name: 'mongod',
        provider: Chef::Provider::Service::Systemd
      )
    end

    it 'should disable service "mongod"' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/lib/systemd/system/mongod.service').and_return(true)
      expect(chef_run).to disable_service('st2 remove systemd mongod service').with(
        service_name: 'mongod',
        provider: Chef::Provider::Service::Systemd
      )
    end

    it 'should delete file "mongod"' do
      expect(chef_run).to delete_file('/lib/systemd/system/mongod.service')
      resource = chef_run.file('/lib/systemd/system/mongod.service')
      expect(resource).to notify('execute[st2-systemctl-daemon-reload]').to(:run).delayed
    end

    it 'should not run execute "st2-systemctl-daemon-reload"' do
      expect(chef_run).to_not run_execute('st2-systemctl-daemon-reload').with(
        command: 'systemctl daemon-reload'
      )
    end

    it 'should create mongodb_instance "instance_name"' do
      skip('mongodb cookbook is missing chefspec matchers')
      expect(chef_run).to_not craete_mongodb_instance('instance_name').with(
        mongodb_type: 'mongod',
        bind_ip: '0.0.0.0',
        port: 27017,
        logpath: '/var/log/mongodb/mongodb.log',
        dbpath: '/var/lib/mongodb',
        enable_rest: false,
        smallfiles: false
      )
    end
  end
end
