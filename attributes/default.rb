default['stackstorm']['api_url'] = 'http://127.0.0.1:9101'
default['stackstorm']['home'] = '/opt/stackstorm'
default['stackstorm']['bin_dir'] = '/usr/bin'
default['stackstorm']['etc_dir'] = '/etc/st2'
default['stackstorm']['conf_path'] = '/etc/st2/st2.conf'
default['stackstorm']['log_dir'] = '/var/log/st2'
default['stackstorm']['run_user'] = 'st2'
default['stackstorm']['run_group'] = 'st2'

# TODO: support customizable workers, default to 10 via package
default['stackstorm']['action_runners'] = 10

# The roles attribute should be specifically defined.
default['stackstorm']['roles'] = []
default['stackstorm']['on_config_update'] = :restart

# Will be populated automaticaly when roles use, unless overrided.
default['stackstorm']['components'] = %w(st2common)
default['stackstorm']['service_binary'] = {}

default['stackstorm']['component_provides'] = {
  st2actions: %w(st2actionrunner st2resultstracker st2notifier),
  st2api: %w(st2api),
  st2reactor: %w(st2rulesengine st2sensorcontainer)
}

# It's recommended to use the install_repo
default['stackstorm']['install_repo']['suite'] = 'stable'
default['stackstorm']['install_repo']['debug_package'] = false
default['stackstorm']['install_repo']['packages'] = %w(st2)
