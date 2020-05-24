$script_hadoop = <<-SCRIPT


  wget -q https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
  sudo tar -C /opt -xzf hadoop-${HADOOP_VERSION}.tar.gz
  sudo ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
  rm hadoop-${HADOOP_VERSION}.tar.gz 

  wget -q https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
  sudo tar -C /opt -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz
  sudo ln -s /opt/apache-hive-${HIVE_VERSION}-bin /opt/hive
  rm apache-hive-${HIVE_VERSION}-bin.tar.gz 

  wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
  sudo tar -C /opt -xzf spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
  sudo ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} /opt/spark
  rm spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz

  sudo apt update
  sudo apt install -y -qq openjdk-8-jdk

  sudo -H -u vagrant bash -c 'cd; cat /dev/zero | ssh-keygen -q -N ""'
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

export SPARK_HOME=/opt/spark
export PATH=\\$SPARK_HOME/bin:\\$PATH
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="lab"
export PYSPARK_PYTHON=python3
EOF

  sudo mkdir -p /app/hadoop/tmp
  sudo mkdir -p /app/hadoop/dfs/namenode
  sudo mkdir -p /app/hadoop/dfs/datanode

  sudo chown -R vagrant:vagrant /app/hadoop
  sudo chmod a+rw -R /app/hadoop/tmp

  chmod a+x /home/vagrant/resources/bin/*
  sudo cp /home/vagrant/resources/bin/* /usr/local/bin
  sudo cp /home/vagrant/resources/hadoop/etc/* /opt/hadoop/etc/hadoop
  sudo sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hadoop/etc/hadoop/core-site.xml
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

  sudo cp /home/vagrant/resources/hive/conf/* /opt/hive/conf
  sudo sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hive/conf/hive-site.xml
  sudo sed -i "s/PW_FOR_HIVE/$MYSQL_HIVE_PASSWD/" /opt/hive/conf/hive-site.xml

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

  sudo rm /opt/hive/lib/guava-19.0.jar
  sudo cp /opt/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib/

  sudo sed -i "s/127.0.0.1/$LOCAL_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf
  sudo systemctl restart mysql.service

  sudo mkdir -p /opt/spark-cluster
  sudo cp /home/vagrant/resources/spark/cluster/* /opt/spark-cluster


  cp /opt/hadoop/etc/hadoop/core-site.xml /opt/spark/conf/
  cp /opt/hadoop/etc/hadoop/hdfs-site.xml /opt/spark/conf/

  sudo cp /home/vagrant/resources/spark/conf/* /opt/spark/conf
  sudo sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/spark/conf/hive-site.xml
  sudo sed -i "s/YOUR_SPARK_VERSION/$SPARK_VERSION/" /opt/spark-cluster/Dockerfile

  sudo apt update
  sudo apt install -y python3-pip default-libmysqlclient-dev

  sudo pip3 install jupyterlab pandas ipython-sql mysqlclient matplotlib pyspark==${SPARK_VERSION}

  sudo su - vagrant -c "cd; jupyter lab --generate-config"
  sudo sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /home/vagrant/.jupyter/jupyter_notebook_config.py
  sudo sed -i "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = ''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
  sudo sed -i "s/#c.NotebookApp.password = u''/c.NotebookApp.password = u''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
  echo "c.NotebookApp.nbserver_extensions.append('ipyparallel.nbextension')" | sudo tee -a /home/vagrant/.jupyter/jupyter_notebook_config.py

  sudo -H -u vagrant bash -c 'cd /opt/spark-cluster && docker-compose build'


  sudo mkdir -p /home/vagrant/notebooks
  sudo cp /home/vagrant/resources/notebooks/* /home/vagrant/notebooks
  sudo chown vagrant:vagrant /home/vagrant/notebooks
  sudo rm -rf /home/vagrant/resources

SCRIPT



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
  #config.vm.network :forwarded_port, guest: 8888, host: 8888, id: 'jupyter'
  #config.vm.network :forwarded_port, guest: 7077, host: 7077, id: 'spark-app'
  #config.vm.network :forwarded_port, guest: 8080, host: 8080, id: 'spark-ui'
  config.vm.network :forwarded_port, guest: 50070, host: 50070, id: 'hadoop'
  config.vm.network :forwarded_port, guest: 8088, host: 8088, id: 'yarn'
  #config.vm.network :forwarded_port, guest: 3306, host: 3306, id: 'mysql'
  #config.vm.network :forwarded_port, guest: 22, host: 2244, id: 'ssh'

  config.vm.provision "shell", path: "scripts/setup-docker.sh"
  config.vm.provision "shell", path: "scripts/setup-hadoop.sh"

  #config.vm.provision "file", source: "resources", destination: "/home/vagrant/resources"
  #config.vm.provision "shell", inline: $script_hadoop

end



=begin


node.vm.provider "virtualbox" do |v|
  v.name = "node#{i}"
  v.customize ["modifyvm", :id, "--memory", "4096"]
      end
node.vm.network :private_network, ip: "10.211.55.10#{i}"
node.ssh.insert_key = false
      
      node.vm.hostname = "node#{i}"
      node.vm.provision "shell", path: "scripts/setup-centos.sh"
node.vm.provision "shell" do |s|
  s.path = "scripts/setup-centos-hosts.sh"
  s.args = "-t #{numNodes}"
end

node.vm.provision "shell", path: "scripts/setup-java.sh"
node.vm.provision "shell", path: "scripts/setup-hadoop.sh"

if i == 2
  node.vm.provision "shell" do |s|
    s.path = "scripts/setup-centos-ssh.sh"
    s.args = "-s 3 -t #{numNodes}"
  end

  node.vm.provision "shell", path: "scripts/setup-hive.sh"
      end

if i == 1
  node.vm.provision "shell" do |s|
    s.path = "scripts/setup-centos-ssh.sh"
    s.args = "-s 2 -t #{numNodes}"
  end
 
  node.vm.provision "shell" do |s|
    s.path = "scripts/setup-mysql.sh"
    s.args = "10.211.55.10#{i}"
  end

  node.vm.provision "shell", path: "scripts/setup-python.sh"

      end
 
node.vm.provision "shell" do |s|
  s.path = "scripts/setup-hadoop-slaves.sh"
  s.args = "-s 3 -t #{numNodes}"
end

node.vm.provision "shell", path: "scripts/setup-spark.sh"
node.vm.provision "shell" do |s|
  s.path = "scripts/setup-spark-slaves.sh"
  s.args = "-s 3 -t #{numNodes}"
      end

if i < 3
  node.vm.provision "shell" do |s|
    s.path = "scripts/setup-cluster.sh"
    s.args = "-n #{i}"
  end
end


yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.7.jar pi 2 100

=end