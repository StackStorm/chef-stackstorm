include_attribute 'stackstorm::user'

# Config defaults options
# Ordered as they appear in original `st2.conf`:
# https://github.com/StackStorm/st2/blob/master/conf/st2.package.conf
default['stackstorm']['config'] = {
  api_url: 'http://127.0.0.1:9101',
  api_host: '127.0.0.1',
  api_port: 9101,
  api_mask_secrets: true,
  api_allow_origin: '*',

  auth_host: '127.0.0.1',
  auth_port: 9100,
  auth_use_ssl: false,
  auth_debug: false,
  auth_enable: true,
  auth_mode: 'standalone',
  auth_backend: 'flat_file',
  auth_backend_kwargs: { 'file_path' => '/etc/st2/htpasswd' },

  syslog_enabled: false,
  syslog_host: '127.0.0.1',
  syslog_port: 514,
  syslog_facility: 'local7',
  syslog_protocol: 'udp',

  log_mask_secrets: true,

  system_user: node['stackstorm']['user']['user'],
  ssh_key_file: "#{node['stackstorm']['user']['home']}/.ssh/stanley_rsa",

  rmq_host: '127.0.0.1',
  rmq_vhost: nil,
  rmq_username: 'guest',
  rmq_password: 'guest',
  rmq_port: 5672,

  db_host: '127.0.0.1',
  db_port: 27017,
  db_name: 'st2',
  db_username: nil,
  db_password: nil,
}
