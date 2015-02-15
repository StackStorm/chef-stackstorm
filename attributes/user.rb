include_attribute 'stackstorm::default'

# StackStorm user is a default user for remote operations which require ssh access.
default['stackstorm']['user']['user'] = 'stanley'
default['stackstorm']['user']['group'] = 'stanley'
default['stackstorm']['user']['home'] = "/home/#{node['stackstorm']['user']['user']}"
default['stackstorm']['user']['authorized_keys'] = []
default['stackstorm']['user']['ssh_key'] = nil
default['stackstorm']['user']['ssh_pub'] = nil
default['stackstorm']['user']['ssh_key_bits'] = 2048
default['stackstorm']['user']['enable_sudo'] = true

default['stackstorm']['config']['system_user'] = {
  user: node['stackstorm']['user']['user'],
  ssh_key_file: "#{node['stackstorm']['user']['home']}/.ssh/id_rsa"
}
