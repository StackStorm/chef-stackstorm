# -*- mode: ruby -*-
# vi: set ft=ruby :

def plugin_installed?(name)
  return if Vagrant.has_plugin?(name)
  puts "Vagrant plugin '#{name}' is NOT installed."
  puts 'Please run:'
  puts "\tvagrant plugin install #{name}"
  exit(1)
end

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = 'bento/centos-7.2'

  # Make sure the needed plugins are installed.
  plugin_installed?('vagrant-berkshelf')
  plugin_installed?('vagrant-omnibus')

  # Enable and configure Berkshelf
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './Berksfile'
  config.omnibus.chef_version = :latest

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: 'dhcp'

  # Enable provisioning with Chef Solo.
  config.vm.provision 'chef_solo' do |chef|
    chef.run_list = [
      'recipe[stackstorm::bundle]'
    ]
  end
end
