default['stackstorm']['version'] = '0.7'
default['stackstorm']['build'] = 'current'
default['stackstorm']['install_method'] = 'system_wide'

default['stackstorm']['home'] = '/opt/stackstorm'
default['stackstorm']['etc_dir'] = '/etc/st2'
default['stackstorm']['conf_path'] = '/etc/st2/st2.conf'
default['stackstorm']['log_dir'] = '/var/log/st2'
default['stackstorm']['runas_user'] = 'st2'
default['stackstorm']['runas_group'] = 'st2'
default['stackstorm']['action_runners'] = node['cpu']['total']

default['stackstorm']['st2_install']['base_url'] = 'https://ops.stackstorm.net/releases/st2'
default['stackstorm']['st2_install']['packages'] = %w(st2common st2reactor st2actions st2api st2auth st2client)

default['stackstorm']['enable_mistral_workflow'] = false

# === StackStorm Configuration attributes responsible for generation.
#

# <---- 
# API listener.
default['stackstorm']['config']['api'] = {
  host: '0.0.0.0',
  port: 9101,
  logging: '/etc/st2api/logging.conf',
}

# Auth listener.
default['stackstorm']['config']['auth'] = {
  host: '0.0.0.0',
  port: 9100,
  debug: false,
  enable: false,
  use_ssl: false,
  mode: 'proxy',
  logging: '/etc/st2auth/logging.conf'
}

default['stackstorm']['config']['st2_webhook_sensor'] = {
  host: '0.0.0.0',
  port: 6000,
  url: '/webhooks/st2/',
}

default['stackstorm']['config']['generic_webhook_sensor'] = {
  host: '0.0.0.0',
  port: 6001,
  url: '/webhooks/generic/',
}
# ---->

default['stackstorm']['config']['sensorcontainer'] = {
  actionexecution_base_url: "http://#{"#{node['stackstorm']['config']['api'][:host]}:#{node['stackstorm']['config']['api'][:port]}"}/actionexecutions",
  logging: '/etc/st2reactor/logging.sensorcontainer.conf',
}

default['stackstorm']['config']['rulesengine'][:logging] = '/etc/st2reactor/logging.rulesengine.conf'
default['stackstorm']['config']['actionrunner'][:logging] = '/etc/st2actions/logging.conf'
default['stackstorm']['config']['history'][:logging] = '/etc/st2actions/logging.history.conf'

default['stackstorm']['config']['log'][:excludes] = 'requests'
default['stackstorm']['config']['system'][:base_path] = node['stackstorm']['home']

default['stackstorm']['config']['ssh_runner'][:remote_dir] = '/tmp'

default['stackstorm']['config']['syslog'] = {
  host: 'localhost',
  port: 514,
  facility: 'local7'
}


# === END points
default['stackstorm']['config']['messaging'][:url] = 'amqp://guest:guest@localhost:5672/'

default['stackstorm']['config']['action_sensor'] = {
  triggers_base_url: "http://localhost:9101/triggertypes/",
  webhook_sensor_base_url: "http://localhost:6000/webhooks/st2/"
}
