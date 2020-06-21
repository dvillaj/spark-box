Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false
  config.vm.hostname = "bigdata-master"
  config.disksize.size = '25GB'

  config.vm.provider "virtualbox" do |vm|
    vm.name = "Spark Box"
  
    vm.cpus = 2
    vm.memory = 8048
  end


  # ssh settings
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
    rm /home/vagrant/.ssh/me.pub
  SHELL


  config.vm.network :private_network, ip: "10.211.55.101"

  # Ports Hadoop
  config.vm.network :forwarded_port, guest: 9870, host: 9870, id: 'namenode'
  config.vm.network :forwarded_port, guest: 9864, host: 9864, id: 'datanode'
  config.vm.network :forwarded_port, guest: 19888, host: 19888, id: 'history_server'
  config.vm.network :forwarded_port, guest: 9046, host: 9046, id: 'proxyserver'
  config.vm.network :forwarded_port, guest: 8088, host: 8088, id: 'yarn'
  config.vm.network :forwarded_port, guest: 8042, host: 8042, id: 'nodemanager'

  # Ports Spark
  config.vm.network :forwarded_port, guest: 8888, host: 8888, id: 'jupyter'
  config.vm.network :forwarded_port, guest: 8080, host: 8080, id: 'spark'

  config.vm.network :forwarded_port, guest: 3306, host: 3306, id: 'mysql'
  config.vm.network :forwarded_port, guest: 27017, host: 27017, id: 'mongo'
  config.vm.network :forwarded_port, guest: 10002, host: 10002, id: 'hive'
  config.vm.network :forwarded_port, guest: 22, host: 2244, id: 'ssh'


  config.vm.provision "shell", path: "scripts/setup-hadoop.sh"
  config.vm.provision "shell", path: "scripts/setup-hive.sh"
  config.vm.provision "shell", path: "scripts/setup-flume.sh"
  config.vm.provision "shell", path: "scripts/setup-mongo.sh"
  config.vm.provision "shell", path: "scripts/setup-docker.sh"
  config.vm.provision "shell", path: "scripts/setup-spark.sh"
  config.vm.provision "shell", path: "scripts/setup-kafka.sh"
  config.vm.provision "shell", path: "scripts/setup-python.sh"
  config.vm.provision "shell", path: "scripts/setup-common.sh"

end


=begin
yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar pi 2 100
beeline -u jdbc:hive2://10.211.55.101:10000

beeline -u jdbc:hive2://10.0.2.15:10000


pyspark --master spark://localhost:7077

https://github.com/simplesteph/kafka-stack-docker-compose

https://tecadmin.net/install-apache-kafka-ubuntu/
https://www.howtoforge.com/how-to-setup-apache-zookeeper-cluster-on-ubuntu-1804/
https://medium.com/@kekayan/a-guide-to-kafka-clustering-in-ubuntu-18-04-5eac0eaf08a2
=end
