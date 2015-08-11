include_attribute 'stackstorm::user'

# Config defaults options
default['stackstorm']['config'] = {
  api_url: 'http://localhost:9101',
  conf_root: '/etc',
  debug: false,
  auth_use_ssl: false,
  auth_enable: true,
  rmq_host: 'localhost',
  rmq_vhost: nil,
  rmq_username: 'guest',
  rmq_password: 'guest',
  rmq_port: 5672,
  allow_origin: '*',
  auth_standalone_file: '/etc/st2/htpasswd',
  syslog_enabled: false,
  syslog_host: 'localhost',
  syslog_port: 514,
  syslog_facility: 'local7',
  syslog_protocol: 'udp',
  system_user: node['stackstorm']['user']['user'],
  ssh_key_file: "#{node['stackstorm']['user']['home']}/.ssh/id_rsa",
  db_host: 'localhost',
  db_port: 27017,
  db_name: 'st2',
  db_username: nil,
  db_password: nil,
  mask_secrets: true
}
