include_attribute 'stackstorm::user'

# Config defaults options
default['stackstorm']['config'] = {
  mask_secrets: true,
  allow_origin: '*',
  debug: false,

  api_url: 'http://127.0.0.1:9101',
  api_host: '0.0.0.0',
  api_port: 9101,

  auth_host: '0.0.0.0',
  auth_port: 9100,
  auth_use_ssl: false,
  auth_enable: true,
  auth_standalone_file: '/etc/st2/htpasswd',

  syslog_enabled: false,
  syslog_host: '127.0.0.1',
  syslog_port: 514,
  syslog_facility: 'local7',
  syslog_protocol: 'udp',

  system_user: node['stackstorm']['user']['user'],
  ssh_key_file: "#{node['stackstorm']['user']['home']}/.ssh/id_rsa",

  rmq_host: '127.0.0.1',
  rmq_vhost: nil,
  rmq_username: 'guest',
  rmq_password: 'guest',
  rmq_port: 5672,

  db_host: '127.0.0.1',
  db_port: 27017,
  db_name: 'st2',
  db_username: nil,
  db_password: nil
}
