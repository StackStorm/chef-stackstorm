# StackStorm Chef Cookbook
[![Build Status](https://travis-ci.org/StackStorm/chef-stackstorm.svg)](https://travis-ci.org/StackStorm/chef-stackstorm)
[![Chef cookbook at Supermarket](https://img.shields.io/cookbook/v/stackstorm.svg?maxAge=2592000)](https://supermarket.chef.io/cookbooks/stackstorm)
[![Join our community Slack](https://stackstorm-community.herokuapp.com/badge.svg)](https://stackstorm.com/community-signup)

Cookbook to install and configure [StackStorm](https://github.com/stackstorm/st2) components using Chef.

> [StackStorm](http://stackstorm.com/) is event-driven automation platform written in Python.
With over [100+ integrations](https://github.com/StackStorm/st2contrib/tree/master/packs) like GitHub, Docker, Nagios, NewRelic, AWS, Chef, Slack it allows you to wire together existing infrastructure into complex Workflows with auto-remediation and many more.
Aka IFTTT orchestration for Ops.

## Supported Platforms
* Ubuntu 14.04 LTS
* RHEL7 / CentOS7

## Requirements
Minimum 2GB of memory and 3.5GB of disk space is required, since StackStorm is shipped with RabbitMQ, PostgreSQL, Mongo and [OpenStack Mistral](https://github.com/stackstorm/chef-openstack-mistral) workflow engine. See [System Requirements](https://docs.stackstorm.com/install/system_requirements.html) for production use.

## Quick Start
For those who want to play with StackStorm, a recipe already exists to get you setup and going with minimal effort:
```rb
recipe[stackstorm::bundle]
```

## Recipes

### `stackstorm:default`
Installs and configures `st2`.
Mind that the valid `config` options must be provided such as `RabbitMQ` and `MongoDB` endpoints.
 Otherwise StackStorm services fail when trying to establish connections.

### `stackstorm::bundle`
All-in-one solution which installs and configures `st2` system services as well as all required dependencies such as `RabbitMQ`, `MongoDB`, [`st2mistral`](https://github.com/StackStorm/chef-openstack-mistral), `Nginx` and [`st2web`](https://github.com/StackStorm/st2web).

### `stackstorm::web`
Installs StackStorm Web UI control panel ([`st2web`](https://github.com/StackStorm/st2web)) and configures `nginx` as a proxy for StackStorm services.
It will generate self-signed certificate by default, see [Install WebUI and setup SSL termination](https://docs.stackstorm.com/install/deb.html#install-webui-and-setup-ssl-termination).

## Attributes
### Common attributes
| Key | Type | Description | Default |
| --- | --- | :--- | --- |
| `['stackstorm']['config']` | Hash | Various options used to build up the `st2.conf` configuration file. | *see [config.rb](attributes/config.rb)* |
| `['stackstorm']['username']` | String | StackStorm username for simple `htpasswd`-based [authentication](https://docs.stackstorm.com/install/deb.html?highlight=flat_file#configure-authentication). | `st2admin` |
| `['stackstorm']['password']` | String | StackStorm password. | `Ch@ngeMe` |

### System User
To run local and remote shell actions, StackStorm uses a special _system user_ (default `stanley`). For remote Linux actions, SSH is used. It is advised to configure SSH key-based authentication on all remote hosts.

| Key | Type | Description | Default |
| --- | --- | --- | --- |
| `['stackstorm']['user']['user']` | String | System user used by stackstorm stack. | `stanley` |
| `['stackstorm']['user']['group']` | String | System group used by stackstorm stack. | `stanley` |
| `['stackstorm']['user']['home']` | String | Path to stanley's home directory. | `/home/stanley` |
| `['stackstorm']['user']['authorized_keys']` | Array | List of ssh public keys added to stanley's `~/.ssh/authorized_keys` file. | `[]` |
| `['stackstorm']['user']['ssh_key']` | String | Stanley's ssh private key. | `nil` |
| `['stackstorm']['user']['ssh_pub']` | String | Stanley's ssh public key. | `nil` |
| `['stackstorm']['user']['ssh_key_bits']` | Integer | Specifies the number of bits for ssh key creation. | `2048` |
| `['stackstorm']['user']['enable_sudo']` | Boolean | Enables sudo privileges for stanley. | `true` |
Stanley's ssh key is automatically generated if no `ssh_key` is provided. If `root` privileges for running actions are required `stanley` must be a valid sudoer. This is the default behavior.

### Web UI
Settings for StackStorm Web UI `st2web` and `nginx`.

| Key | Type | Description | Default |
| --- | --- | --- | --- |
| `['stackstorm']['web']['ssl']['self_signed']['enabled']` | Boolean | Enable self-signed certificate generation. | `true` |
| `['stackstorm']['web']['ssl']['self_signed']['org']` | String | Self-signed certificate `O` field. | `StackStorm` |
| `['stackstorm']['web']['ssl']['self_signed']['org_unit']` | String | Self-signed certificate `OU` field. | `Information Technology` |
| `['stackstorm']['web']['ssl']['self_signed']['country']` | String | Self-signed certificate `C` field. | `US` |

## Authors
* Author:: StackStorm (st2-dev) (<info@stackstorm.com>)
* Author:: [Eugen C.](https://github.com/armab/) (<armab@stackstorm.com>)
* Author:: [Denis Baryshev](https://github.com/armab/) (<dennybaa@gmail.com>)
* Contributor:: [Bao Nguyen](https://github.com/sysbot) (<ngqbao@gmail.com>)
* Contributor:: [Grant Ridder](https://github.com/shortdudey123)
* Contributor:: [Javier Palomo Almena](https://github.com/jvrplmlmn)

## Other Installers
You might be interested in other methods to deploy StackStorm engine:
* Configuration Management
  * [Ansible Playbooks](https://github.com/stackstorm/ansible-st2)
  * [Puppet Module](https://github.com/stackstorm/puppet-st2)

* Manual Instructions
  * [Ubuntu](https://docs.stackstorm.com/install/deb.html)
  * [RHEL7/CentOS7](https://docs.stackstorm.com/install/rhel7.html)
  * [RHEL6/CentOS6](https://docs.stackstorm.com/install/rhel6.html)
