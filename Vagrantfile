Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "BigData Box"
  
    vb.cpus = 2
    vb.memory = 8048
  end

  # ssh settings
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
    rm /home/vagrant/.ssh/me.pub
  SHELL

  config.vm.network :private_network, ip: "10.211.55.101"

  config.vm.synced_folder "src/", "/src"

  # Ports
  config.vm.network :forwarded_port, guest: 8888, host: 8888, id: 'jupyter'
  config.vm.network :forwarded_port, guest: 7077, host: 7077, id: 'spark-app'
  config.vm.network :forwarded_port, guest: 4040, host: 4040, id: 'spark'
  config.vm.network :forwarded_port, guest: 8080, host: 8080, id: 'spark-ui'
  config.vm.network :forwarded_port, guest: 50070, host: 50070, id: 'hadoop'
  config.vm.network :forwarded_port, guest: 8088, host: 8088, id: 'yarn'
  config.vm.network :forwarded_port, guest: 3306, host: 3306, id: 'mysql'
  config.vm.network :forwarded_port, guest: 22, host: 2244, id: 'ssh'

  config.vm.provision "shell", path: "scripts/setup-docker.sh"
  config.vm.provision "shell", path: "scripts/setup-python.sh"
  config.vm.provision "shell", path: "scripts/setup-hadoop.sh"
  config.vm.provision "shell", path: "scripts/setup-spark.sh"
  config.vm.provision "shell", path: "scripts/setup-cluster.sh"
end


=begin


yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.7.jar pi 2 100

beeline -u jdbc:hive2://localhost:10000/


=end