function mac_vm {

# Install virtualbox and vagrant
brew install --cask virtualbox
brew install --cask vagrant
#for guest additions
vagrant plugin install vagrant-vbguest  

# Test installed
if ! which virtualbox >/dev/null 2>&1 ; then announce "virtualbox couldn't be installed. Aborting." ; return 1 ; fi 

# Install debian vm
mkdir $HOME/parmanode/debian_vm
cd $HOME/parmanode/debian_vm
vagrant init debian/bullseye64

# Make Vagrantfile
# Need to pass in variables...
# Setup script included in config.vim.provision block
cat > ./Vagrantfile << EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

config.vm.box = "debian/bullseye64"
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"  # Set VM to have 2GB of RAM
    vb.cpus = 2        # Set VM to use 2 CPUs
    vb.customize ["modifyvm", :id, "--vram", "16"]
end

config.vbguest.auto_update = true

config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y vim fdisk sudo 
SHELL
end

EOF

# Start Vagrant machine
vagrant up

# Access Vagrant via SSH
vagrant ssh

# Stop/pause machine
vagrant halt # and vagrant up to restart

# End/delete machine
vagrant destroy

# if changes to vagrant file
vagrant reload --provision





}