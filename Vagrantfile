$script_hadoop = <<-SCRIPT

  export MYSQL_ROOT_PASSWD="adsfsa121212"
  export MYSQL_HIVE_PASSWD="fsdwe2342341"

  wget -q https://downloads.apache.org/hadoop/common/hadoop-3.1.3/hadoop-3.1.3.tar.gz
  sudo tar -C /opt -xzf hadoop-3.1.3.tar.gz
  sudo ln -s /opt/hadoop-3.1.3 /opt/hadoop
  rm hadoop-3.1.3.tar.gz 

  wget -q https://downloads.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
  sudo tar -C /opt -xzf apache-hive-3.1.2-bin.tar.gz
  sudo ln -s /opt/apache-hive-3.1.2-bin /opt/hive
  rm apache-hive-3.1.2-bin.tar.gz 

  sudo apt update
  sudo apt install -y -qq openjdk-8-jdk

  cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  cat << EOF >> /home/vagrant/.bashrc

export HADOOP_HOME=/opt/hadoop
export HADOOP_INSTALL=\\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\\$HADOOP_HOME
export HADOOP_COMMON_HOME=\\$HADOOP_HOME
export HADOOP_HDFS_HOME=\\$HADOOP_HOME
export YARN_HOME=\\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\\$HADOOP_HOME/lib/native
export PATH=\\$PATH:\\$HADOOP_HOME/sbin:\\$PATH:\\$HADOOP_HOME/bin:\\$HADOOP_HOME/binexport 

export LD_LIBRARY_PATH=\\$HADOOP_HOME/lib/native:\\$LD_LIBRARY_PATH
export HIVE_HOME=/opt/hive
export PATH=\\$PATH:\\$HIVE_HOME/bin
EOF

  sudo mkdir -p /app/hadoop/tmp
  sudo mkdir -p /app/hadoop/dfs/namenode
  sudo mkdir -p /app/hadoop/dfs/datanode

  sudo chown -R vagrant:vagrant /app/hadoop
  sudo chmod a+rw -R /app/hadoop/tmp

  chmod a+x /home/vagrant/resources/bin/*
  sudo cp /home/vagrant/resources/bin/* /usr/local/bin
  sudo cp /home/vagrant/resources/etc/hadoop/* /opt/hadoop/etc/hadoop
  export LOCAL_IP=`hostname -I | xargs`
  sudo sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hadoop/etc/hadoop/core-site.xml
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

  sudo cp /home/vagrant/resources/hive/conf/* /opt/hive/conf
  sudo sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hive/conf/hive-site.xml
  sudo sed -i "s/PW_FOR_HIVE/$MYSQL_HIVE_PASSWD/" /opt/hive/conf/hive-site.xml

  sudo -H -u vagrant bash -c 'echo "I am $USER, with uid $UID"'

  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWD"
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWD"
  sudo apt-get -y install mysql-server

  wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz
  tar -xzf mysql-connector-java-8.0.19.tar.gz
  sudo cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar /opt/hive/lib/
  rm -rf mysql-connector-java-8.0.19*

  cat << EOF > ~/.my.cnf
[mysql]
user = root
password = $MYSQL_ROOT_PASSWD
EOF


  sudo sed -i "s/PW_FOR_HIVE/$MYSQL_HIVE_PASSWD/" /home/vagrant/resources/hive/hive-init.sql
  mysql < /home/vagrant/resources/hive/hive-init.sql 
  sudo rm -rf /home/vagrant/resources

  sudo rm /opt/hive/lib/guava-19.0.jar
  sudo cp /opt/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib/

  sudo sed -i "s/127.0.0.1/$LOCAL_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf
  sudo systemctl restart mysql.service

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
  config.vm.network :forwarded_port, guest: 9870, host: 9870, id: 'hadoop'
  config.vm.network :forwarded_port, guest: 8088, host: 8088, id: 'yarn'
  config.vm.network :forwarded_port, guest: 22, host: 2244, id: 'ssh'

  config.vm.provision "file", source: "resources", destination: "/home/vagrant/resources"
  config.vm.provision "shell", inline: $script_hadoop

end

=begin
  sudo apt update
  sudo apt install -y -qq apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt install -y docker-ce

  sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose


  

=end