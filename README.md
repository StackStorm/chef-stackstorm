# Stackstorm chef cookbook

Cookbook for [StackStorm](http://www.stackstorm.com) Automation as a Service. This cookbook is used to install and bring up **St2** components using Chef.


## Supported Platforms

Packaging for **St2** is currently done via *apt* or *rpm* packages, which can be found here https://ops.stackstorm.net/releases/st2.


* **rhel family** >= 7.0
* **ubuntu** >= 12.04

## Attributes

### Common attributes

| Key | Type | Description | Default |
| --- | :---: | :--- | :---: |
| `['stackstorm']['install_method']` | String | StackStorm installation method. | `'system_wide'` |
| `['stackstorm']['version']` | String | Version of stack **St2** to be installed.  | `'0.7'` |
| `['stackstorm']['build']` | String | Build number of stackstorm packages. | `'current'` |
| `['stackstorm']['home']` | String | Base directory where is **St2** is installed (same path as in the *os-packages*). | `'/opt/stackstorm'` |
| `['stackstorm']['etc_dir']` | String | Configuration directory of **St2**. | `'/etc/st2'` |
| `['stackstorm']['conf_path']` | String | **St2** configuration file path. | `'/etc/st2/st2.conf'` |
| `['stackstorm']['log_dir']` | String | Log directory path where **St2** services write log files. | `'/var/log/st2'` |
| `['stackstorm']['runas_user']` | String | User used to run **St2** services (execept *action runners*). | `'st2'` |
| `['stackstorm']['runas_group']` | String | Group used to run **St2** services (execept *action runners*). | `'st2'` |
| `['stackstorm']['action_runners']` | Integer | Number of *action runners* to be spawned. | `node['cpu']['total']` |
| `['stackstorm']['enable_mistral_workflow']` | Boolean | Enables installation of *Mistral Workflow Service* componentts. | `true` |
| `['stackstorm'][config']` | Hash | Various configuration options used to build up the configuration file. | *see attributes file* |

### User management

| Key | Type | Description | Default |
| --- | :---: | :--- | :---: |
| `['stackstorm']['user']['user']` | String | System user used by stackstorm stack. | `'stanley'` |
| `['stackstorm']['user']['group']` | String | System group used by stackstorm stack. | `'stanley'` |
| `['stackstorm']['user']['home']` | String | Path to stanley's home directoy. | `'/home/stanley'` |
| `['stackstorm']['user']['authorized_keys']` | Array | List of ssh public keys added to stanley's* ~/.ssh/authorized_keys* file. | `[]` |
| `['stackstorm']['user']['ssh_key']` | String | Stanley's ssh private key. | `nil` |
| `['stackstorm']['user']['ssh_pub']` | String | Stanley's ssh public key. | `nil` |
| `['stackstorm']['user']['ssh_key_bits']` | Integer | Specifies the number of bits for ssh key creation. | `2048` |
| `['stackstorm']['user']['enable_sudo']` | Boolean | Enables sudo privileges for stanley. | `true` |

Stackstorm uses **system_user** option to specify privileges used to execute local or remote actions. This user is managed and configured by this cookbook. **Stanley** user is different from **runas_user** whose privileges used for running **all St2** services (except *action runners*). Action runners are started with **root** privileges and stackstorm drops them to *stanley's* priviliges. If **root** privileges for running actions are required *stanley* must be valid sudoer.

Stanley's ssh key is automatically generated if no **ssh_key** is provided. This is the default behavior.

## Usage

Stackstorm nodes can have several roles these are **controller** and **worker**. **Controller** nodes run *API service*, *sensor container* and others. While workers execute actions on nodes so they run only *action runner* and *mistral executor* services.

### stackstorm::controller and stackstorm::worker

Depending on which role you need on a server you might include either `recipe[stackstorm::controller]` or `recipe[stackstorm::worker]`. After converging a node, **St2** packages are downloaded, system init files are genereted and service are started. **Mind that the valid configuration must be provided such as RabbitMQ and MongoDB endpoints**.

### stackstorm::bundle

For those who wants to play with stackstorm there's an *all-in-one* solution which installs and configures stackstorm system services as well as required components such as *RabbitMQ and MongoDB*. Include the **bundle recipe** and you can work with pre-configured *Stackstorm* bundle.


## License and Authors

* Author:: StackStorm (st2-dev) (<info@stackstorm.com>)
* Author:: Denis Baryshev (<dennybaa@gmail.com>)
