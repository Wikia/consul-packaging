# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

$install = <<INSTALL
sudo apt-get update -q
sudo apt-get install -y -qq ruby-dev build-essential curl unzip
sudo /opt/vagrant_ruby/bin/gem install fpm --no-ri --no-rdoc
INSTALL

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise64'
  config.vm.provision 'shell', inline: $install
  config.vm.synced_folder '.', '/home/vagrant/src'
  if Vagrant.has_plugin?('vagrant-vbguest') then
    config.vbguest.auto_update = false
  end
end
