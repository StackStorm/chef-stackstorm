name 'stackstorm'
maintainer 'StackStorm (st2-dev)'
maintainer_email 'info@stackstorm.com'
license 'Apache-2.0'
description 'Installs/Configures stackstorm'
long_description 'Installs/Configures stackstorm'
version '0.7.0'

supports 'ubuntu', '= 14.04'
supports 'redhat', '~> 7.5'
supports 'centos', '~> 7.5'
supports 'amazon'

chef_version '>= 14.4'

depends 'apt'
depends 'chef_nginx', '~> 5.0.1'
depends 'database'
depends 'htpasswd'
depends 'sc-mongodb', '~> 1.2.0'
depends 'openssl', '~> 6.0.0'
depends 'openstack-mistral', '>= 0.3.0'
depends 'packagecloud'
depends 'postgresql', '=6.1.1'
depends 'rabbitmq'
depends 'yum'

source_url 'https://github.com/StackStorm/chef-stackstorm' if respond_to?(:source_url)
issues_url 'https://github.com/StackStorm/chef-stackstorm/issues' if respond_to?(:issues_url)
