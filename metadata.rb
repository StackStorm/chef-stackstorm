name 'stackstorm'
maintainer 'StackStorm (st2-dev)'
maintainer_email 'info@stackstorm.com'
license 'Apache 2.0'
description 'Installs/Configures stackstorm'
long_description 'Installs/Configures stackstorm'
version '0.4.0'

supports 'ubuntu', '= 14.04'
supports 'redhat', '~> 7.0'
supports 'centos', '~> 7.0'
supports 'amazon'

depends 'apt'
depends 'chef_nginx', '~> 5.0.1'
depends 'database'
depends 'htpasswd'
depends 'mongodb3', '~> 5.3.0'
depends 'openssl', '~> 6.0.0'
depends 'openstack-mistral', '>= 0.3.0'
depends 'packagecloud'
depends 'postgresql'
# For newer RabbitMQ cookbook versions, service fails to start in Dockerized environment under EL7
# See: https://github.com/StackStorm/chef-stackstorm/pull/62
depends 'rabbitmq', '<= 4.10.0'
depends 'sudo'
depends 'yum'
depends 'yum-epel'

source_url 'https://github.com/StackStorm/chef-stackstorm' if respond_to?(:source_url)
issues_url 'https://github.com/StackStorm/chef-stackstorm/issues' if respond_to?(:issues_url)
