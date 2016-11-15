require 'spec_helper'

describe 'stackstorm::config' do
  before do
    global_stubs_include_recipe
  end

  context 'with default node attributes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    let(:st2_conf) do
      %(# System-wide configuration

[api]
# Host and port to bind the API server.
host = 0.0.0.0
port = 9101
logging = /etc/st2/logging.api.conf
mask_secrets = true
# allow_origin is required for handling CORS in st2 web UI.
# allow_origin = http://myhost1.example.com:3000,http://myhost2.example.com:3000
allow_origin = *

[stream]
logging = /etc/st2/logging.stream.conf

[sensorcontainer]
logging = /etc/st2/logging.sensorcontainer.conf

[rulesengine]
logging = /etc/st2/logging.rulesengine.conf

[actionrunner]
logging = /etc/st2/logging.actionrunner.conf
virtualenv_opts = --always-copy

[resultstracker]
logging = /etc/st2/logging.resultstracker.conf

[notifier]
logging = /etc/st2/logging.notifier.conf

[exporter]
logging = /etc/st2/logging.exporter.conf

[garbagecollector]
logging = /etc/st2/logging.garbagecollector.conf

[auth]
host = 0.0.0.0
port = 9100
use_ssl = False
debug = False
enable = True
logging = /etc/st2/logging.auth.conf

mode = standalone

# Note: Settings bellow are only used in "standalone" mode
backend = flat_file
backend_kwargs = {"file_path": "/etc/st2/htpasswd"}

# Base URL to the API endpoint excluding the version (e.g. http://myhost.net:9101/)
api_url = http://127.0.0.1:9101

[system]
base_path = /opt/stackstorm

# [webui]
# webui_base_url = https://mywebhost.domain

[syslog]
host = 127.0.0.1
port = 514
facility = local7
protocol = udp

[log]
excludes = requests,paramiko
redirect_stderr = False
mask_secrets = True

[system_user]
user = stanley
ssh_key_file = /home/stanley/.ssh/id_rsa

[messaging]
url = amqp://guest:guest@127.0.0.1:5672/

[ssh_runner]
remote_dir = /tmp

[action_sensor]
triggers_base_url = http://127.0.0.1:9101/v1/triggertypes/

[database]
host = 127.0.0.1
port = 27017
db_name = st2
)
    end

    it 'should include recipe stackstorm::user' do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::user')
      chef_run
    end

    it 'should not create file ":backup StackStorm dist configuration" if st2.conf does not exist' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/st2/st2.conf').and_return(false)
      expect(chef_run).to_not create_file(':backup StackStorm dist configuration').with(
        path: '/etc/st2/st2.conf.dist'
      )
    end

    it 'should not create file ":backup StackStorm dist configuration" if st2.conf.dist exists' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/st2/st2.conf.dist').and_return(true)
      expect(chef_run).to_not create_file(':backup StackStorm dist configuration').with(
        path: '/etc/st2/st2.conf.dist'
      )
    end

    it 'should create file ":backup StackStorm dist configuration" if conditions are met' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/st2/st2.conf').and_return(true)
      allow(IO).to receive(:read).and_call_original
      allow(IO).to receive(:read).with('/etc/st2/st2.conf').and_return(st2_conf)
      expect(chef_run).to create_file(':backup StackStorm dist configuration').with(
        path: '/etc/st2/st2.conf.dist',
        content: st2_conf
      )
    end

    it 'should create template ":create StackStorm configuration"' do
      expect(chef_run).to create_template(':create StackStorm configuration').with(
        path: '/etc/st2/st2.conf',
        owner: 'root',
        group: 'root',
        mode: 0644,
        source: 'st2.conf.erb',
        variables: {
          'api_url' => 'http://127.0.0.1:9101',
          'debug' => false,
          'auth_use_ssl' => false,
          'auth_enable' => true,
          'rmq_host' => '127.0.0.1',
          'rmq_vhost' => nil,
          'rmq_username' => 'guest',
          'rmq_password' => 'guest',
          'rmq_port' => 5672,
          'allow_origin' => '*',
          'auth_standalone_file' => '/etc/st2/htpasswd',
          'syslog_enabled' => false,
          'syslog_host' => '127.0.0.1',
          'syslog_port' => 514,
          'syslog_facility' => 'local7',
          'syslog_protocol' => 'udp',
          'system_user' => 'stanley',
          'ssh_key_file' => '/home/stanley/.ssh/id_rsa',
          'db_host' => '127.0.0.1',
          'db_port' => 27017,
          'db_name' => 'st2',
          'db_username' => nil,
          'db_password' => nil,
          'mask_secrets' => true
        }
      )
    end

    it 'should create directory "st2:log_dir"' do
      expect(chef_run).to create_directory('st2:log_dir').with(
        path: '/var/log/st2',
        owner: 'st2',
        group: 'st2',
        mode: '0755'
      )
    end
  end
end
