default['stackstorm']['version'] = '0.7'
default['stackstorm']['build'] = 'current'
default['stackstorm']['install_method'] = 'stackstorm'

default['stackstorm']['home'] = '/opt/stackstorm'
default['stackstorm']['bin_dir'] = '/usr/bin'
default['stackstorm']['etc_dir'] = '/etc/st2'
default['stackstorm']['conf_path'] = '/etc/st2/st2.conf'
default['stackstorm']['log_dir'] = '/var/log/st2'
default['stackstorm']['runas_user'] = 'st2'
default['stackstorm']['runas_group'] = 'st2'
default['stackstorm']['roles'] = %w(contoller worker client)
default['stackstorm']['action_runners'] = node['cpu']['total']

# Will be set by actual install provider
default['stackstorm']['python_binary'] = nil

# Will be populated automaticaly when roles use, unless overrided.
default['stackstorm']['components'] = []
default['stackstorm']['service_binary'] = {
  st2history: 'history',
  st2actionrunner: 'actionrunner',
  st2rulesengine: 'rules_engine',
  st2sensorcontainer: 'sensor_container'
}

default['stackstorm']['component_provides'] = {
  st2actions: %w(st2history st2actionrunner),
  st2api: %w(st2api),
  st2reactor: %w(st2rulesengine st2sensorcontainer)
}

default['stackstorm']['install_stackstorm']['base_url'] = 'https://ops.stackstorm.net/releases/st2'
default['stackstorm']['install_stackstorm']['packages'] = %w(st2common st2reactor st2actions st2api st2auth st2client)
