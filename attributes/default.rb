default['stackstorm']['install_method'] = value_for_platform({
  "ubuntu" => { "14.04" => "repo", "default" => "stackstorm" },
  "redhat" => { "6" => "repo", "default" => "stackstorm" },
  "fedora" => { "20" => "repo", "default" => "stackstorm" },
  "default" => "stackstorm"
})

default['stackstorm']['api_url'] = "http://127.0.0.1:9101"
default['stackstorm']['home'] = '/opt/stackstorm'
default['stackstorm']['bin_dir'] = '/usr/bin'
default['stackstorm']['etc_dir'] = '/etc/st2'
default['stackstorm']['conf_path'] = '/etc/st2/st2.conf'
default['stackstorm']['log_dir'] = '/var/log/st2'
default['stackstorm']['run_user'] = 'st2'
default['stackstorm']['run_group'] = 'st2'
default['stackstorm']['action_runners'] = node['cpu']['total']
# The roles attribute should be specifically defined.
default['stackstorm']['roles'] = []
default['stackstorm']['on_config_update'] = :restart

# Will be set by actual install provider
default['stackstorm']['python_binary'] = nil

# Will be populated automaticaly when roles use, unless overrided.
default['stackstorm']['components'] = %w(st2common)
default['stackstorm']['service_binary'] = {}

default['stackstorm']['component_provides'] = {
  st2actions: %W(st2actionrunner st2resultstracker st2notifier),
  st2api: %w(st2api),
  st2reactor: %w(st2rulesengine st2sensorcontainer)
}

default['stackstorm']['install_stackstorm']['build'] = 'current'
default['stackstorm']['install_stackstorm']['version'] = '0.12.1'
default['stackstorm']['install_stackstorm']['base_url'] = 'https://downloads.stackstorm.net/releases/st2'
default['stackstorm']['install_stackstorm']['packages'] = %w(st2common st2reactor st2actions st2api st2auth st2client)

default['stackstorm']['install_repo']['suite'] = 'stable'
default['stackstorm']['install_repo']['debug_package'] = false

case node['platform_family']
when 'debian'
  default['stackstorm']['install_repo']['packages'] = %w(st2actions st2api
    st2auth st2common st2reactor python-st2client)
  default['stackstorm']['install_repo']['base_url'] = "https://downloads.stackstorm.net/deb"
when 'fedora', 'rhel'
  default['stackstorm']['install_repo']['packages'] = %w(st2actions st2api
    st2auth st2common st2reactor st2client)
  default['stackstorm']['install_repo']['base_url'] = "https://downloads.stackstorm.net/rpm/#{node[:platform]}/#{node[:platform_version]}/#{node['stackstorm']['install_repo']['suite']}"
end
