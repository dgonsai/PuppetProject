# -*- mode: ruby -*-
# vi: set ft=ruby :


# NEW VAGRANT FILE - DPS

$MasterScript = <<SCRIPT
sudo apt-get install -y openssh-server openssh-client
sudo apt-get update -y
sudo apt-get install -y puppet puppetmaster
sudo ufw disable
sudo touch /etc/puppet/autosign.conf
sudo echo 'Agent.netbuilder.private' >> /etc/puppet/autosign.conf
sudo sed -i -e '1i127.0.0.1    Master.netbuilder.private' /etc/hosts
sudo sed -i -e '1i10.50.15.184    Master.netbuilder.private    puppetmaster' /etc/hosts
SCRIPT

$AgentScript = <<SCRIPT
sudo apt-get install -y openssh-server openssh-client
sudo apt-get update -y
sudo ufw disable
sudo puppet agent --enable
sudo sed -i -e '1i10.50.15.185  Agent.netbuilder.private    puppet' /etc/hosts
sudo sed -i -e '1i127.0.0.1     Agent.netbuilder.private    puppet' /etc/hosts
sudo sed -i -e '1i10.50.15.184  Master.netbuilder.private   puppetmaster' /etc/hosts
sudo sed -i -e '2iserver=Master.netbuilder.private' /etc/puppet/puppet.conf
sudo puppet --test --server=Master.netbuilder.private
SCRIPT


Vagrant.configure(2) do |o|
  o.vm.box = "ubuntu/trusty64"
  o.vm.synced_folder "puppet", "/opt/puppet"
  o.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.manifest_file = 'site.pp'
  end


  o.vm.define "master" do |master|
    master.vm.network "public_network", ip: "10.50.15.184"
    master.vm.hostname = "Master"
	master.vm.provision "shell", inline: $MasterScript
  end  
  
  
  o.vm.define "agent" do |agent|
    agent.vm.network "public_network",  ip: "10.50.15.185"
	agent.vm.hostname = "Agent"
	agent.vm.provision "shell", inline: $AgentScript
  end
  
   
  
end





  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"	
	
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  
  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline <<-SHELL
  # sudo apt-get install -y wget
  # SHELL

