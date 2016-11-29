# -*- mode: ruby -*-
# vi: set ft=ruby :

def plugin_installed?(name)
  return if Vagrant.has_plugin?(name)
  puts "Vagrant plugin '#{name}' is NOT installed."
  puts 'Please run:'
  puts "\tvagrant plugin install #{name}"
  exit(1)
end

# Make sure the needed plugins are installed.
plugin_installed?('vagrant-berkshelf')
plugin_installed?('vagrant-omnibus')

Vagrant.require_version '>= 1.5.0'
Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'chef-stackstorm'
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: 'dhcp'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    # Required for StackStorm to run properly
    vb.memory = 2048
  end

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = ['www.chef-stackstorm']
    config.vm.provision :hostmanager
  end

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = 'latest'

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[stackstorm::default]'
    ]
  end
end
