require 'spec_helper'

describe 'stackstorm::config' do
  before do
    global_stubs_include_recipe
  end

  let(:st2_conf) do
    %(# System-wide configuration

[api]
# Host and port to bind the API server.
host = 0.0.0.0
port = 9101
logging = /etc/st2/logging.api.conf
mask_secrets = True
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

[timersengine]
logging = /etc/st2timersengine/logging.st2timersengine.conf

[workflow_engine]
logging = /etc/st2actions/logging.workflowengine.conf

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

  platforms = {
    'ubuntu' => ['14.04'],
    'centos' => ['7.5'],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "Using #{platform} #{version} with default node attributes" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

        it 'should create /etc/st2 directory with attributes' do
          expect(chef_run).to create_directory('/etc/st2').with(
            user: 'root',
            group: 'root',
            mode: '0755'
          )
        end

        it 'should include recipe stackstorm::user' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('stackstorm::user')
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
            # Config options ordered as they appear in original `st2.conf`:
            # https://github.com/StackStorm/st2/blob/master/conf/st2.package.conf
            variables: {
              'api_url' => 'http://127.0.0.1:9101',
              'api_host' => '0.0.0.0',
              'api_port' => 9101,
              'api_mask_secrets' => True,
              'api_allow_origin' => '*',

              'auth_host' => '0.0.0.0',
              'auth_port' => 9100,
              'auth_use_ssl' => False,
              'auth_debug' => False,
              'auth_enable' => True,
              'auth_standalone_file' => '/etc/st2/htpasswd',

              'syslog_enabled' => False,
              'syslog_host' => '127.0.0.1',
              'syslog_port' => 514,
              'syslog_facility' => 'local7',
              'syslog_protocol' => 'udp',

              'log_mask_secrets' => True,

              'system_user' => 'stanley',
              'ssh_key_file' => '/home/stanley/.ssh/id_rsa',

              'rmq_host' => '127.0.0.1',
              'rmq_vhost' => nil,
              'rmq_username' => 'guest',
              'rmq_password' => 'guest',
              'rmq_port' => 5672,

              'db_host' => '127.0.0.1',
              'db_port' => 27017,
              'db_name' => 'st2',
              'db_username' => nil,
              'db_password' => nil,
            }
          )
        end
      end
    end
  end
end
