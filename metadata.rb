name 'stackstorm'
maintainer 'StackStorm (st2-dev)'
maintainer_email 'info@stackstorm.com'
license 'Apache 2.0'
description 'Installs/Configures stackstorm'
long_description 'Installs/Configures stackstorm'
version '0.4.0'

supports 'debian'
supports 'ubuntu'
supports 'redhat'
supports 'centos'
supports 'amazon'

depends 'sudo'
depends 'gdebi'
depends 'rabbitmq', '>= 3.12.0'
depends 'mongodb3', '~> 5.3.0'
depends 'postgresql'
depends 'database'
depends 'openstack-mistral', '>= 0.3.0'
depends 'apt'
depends 'yum'
depends 'yum-epel'
depends 'hostsfile'
depends 'packagecloud'

source_url 'https://github.com/StackStorm/chef-stackstorm' if respond_to?(:source_url)
issues_url 'https://github.com/StackStorm/chef-stackstorm/issues' if respond_to?(:issues_url)
