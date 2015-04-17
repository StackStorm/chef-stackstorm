# === StackStorm Configuration attributes responsible for generation.
#

# <----
# API listener.
default['stackstorm']['config']['api'] = {
  host: '0.0.0.0',
  port: 9101,
  logging: '/etc/st2api/logging.conf',
  serve_webui_files: true
}

# Auth listener.
default['stackstorm']['config']['auth'] = {
  host: '0.0.0.0',
  port: 9100,
  debug: false,
  enable: false,
  use_ssl: false,
  mode: 'proxy',
  logging: '/etc/st2auth/logging.conf',
  api_url: %Q(#{node['stackstorm']['api_url']})
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

# St2 API URL
default['stackstorm']['config']['sensorcontainer'] = {
  actionexecution_base_url: %Q(#{node['stackstorm']['api_url']}/actionexecutions/),
  logging: '/etc/st2reactor/logging.sensorcontainer.conf'
}

default['stackstorm']['config']['rulesengine'][:logging] = '/etc/st2reactor/logging.rulesengine.conf'
default['stackstorm']['config']['actionrunner'][:logging] = '/etc/st2actions/logging.conf'
default['stackstorm']['config']['resultstracker'][:logging] = '/etc/st2actions/logging.resultstracker.conf'

default['stackstorm']['config']['log'] = {
  excludes: 'requests,paramiko',
  redirect_stderr: false
}
default['stackstorm']['config']['system'][:base_path] = node['stackstorm']['home']

default['stackstorm']['config']['ssh_runner'][:remote_dir] = '/tmp'

default['stackstorm']['config']['syslog'] = {
  host: 'localhost',
  port: 514,
  facility: 'local7',
  protocol: 'udp'
}


# === END points
default['stackstorm']['config']['messaging'][:url] = 'amqp://guest:guest@localhost:5672/'

default['stackstorm']['config']['action_sensor'] = {
  triggers_base_url: %Q(#{node['stackstorm']['api_url']}/triggertypes/)
}
