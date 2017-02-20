# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # https://atlas.hashicorp.com/centos/boxes/7
  config.vm.box = "centos/7"
  config.vm.box_version = "1611.01"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.name = "centos7_development"
  end

  config.vm.provision "shell", privileged: false, path: "bin/setup.sh"
end
