$script_install = <<-SCRIPT
  sudo apt update
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt install -y docker-ce

  sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

SCRIPT

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-18.04"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Spark Box"
  
    vb.cpus = 2
    vb.memory = 8048
  end


  # ssh settings
  config.ssh.insert_key = false
  config.ssh.private_key_path = ["~/.ssh/id_rsa", "#{ENV['VAGRANT_HOME']}/insecure_private_key"]
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

  # Private Key
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision "shell", inline: "chmod 400 /home/vagrant/.ssh/id_rsa"

  # Ports
  #config.vm.network :forwarded_port, guest: 8098, host: 8098, id: 'riak-http'
  config.vm.network :forwarded_port, guest: 22, host: 2244, id: 'ssh'

  config.vm.provision "shell", inline: $script_install

end

=begin


=end