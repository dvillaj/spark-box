#!/bin/bash
source "/vagrant/scripts/common.sh"


function installHive {
	echo "installing hive"

    wget -q https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
    tar -C /opt -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz
    ln -s /opt/apache-hive-${HIVE_VERSION}-bin /opt/hive
    rm apache-hive-${HIVE_VERSION}-bin.tar.gz 

    mkdir -p /opt/hive/logs
    touch /opt/hive/logs/hive2.log
    touch /opt/hive/logs/metastore.log 

    chown -R vagrant:vagrant /opt/apache-hive-${HIVE_VERSION}-bin
}

function installMysqlConnector {
    wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz
    tar -xzf mysql-connector-java-8.0.19.tar.gz
    cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar /opt/hive/lib/
    rm -rf mysql-connector-java-8.0.19*
}

function installMysql {
	echo "installing mysql"

    debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWD"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWD"
    apt -y install mysql-server

    sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
    systemctl restart mysql.service
}

function setupMysql {
	echo "seting up mysql"

	cp -f $RESOURCES_DIR/hive/.my.cnf /root
    sed -i "s/PW_FOR_ROOT/$MYSQL_ROOT_PASSWD/" /root/.my.cnf

	cp -f $RESOURCES_DIR/hive/sql/*.sql /root
    sed -i "s/PW_FOR_HIVE/$MYSQL_HIVE_PASSWD/" /root/hive-init.sql
    mysql < /root/hive-init.sql 
    rm /root/hive-init.sql 

    mysql < /root/admin-user.sql 
    rm /root/admin-user.sql 
}


function setupHive {
	echo "seting up hive"

	cp -f $RESOURCES_DIR/hive/config/*.xml /opt/hive/conf
    sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hive/conf/hive-site.xml
    sed -i "s/PW_FOR_HIVE/$MYSQL_HIVE_PASSWD/" /opt/hive/conf/hive-site.xml

 	cp -f $RESOURCES_DIR/hive/config/hive.sh /etc/profile.d

    rm /opt/hive/lib/guava-19.0.jar
    cp /opt/hadoop/share/hadoop/hdfs/lib/guava*-jre.jar /opt/hive/lib/

    /opt/hive/bin/schematool --verbose -dbType mysql -initSchema

}


echo "setup hive"
installHive
installMysqlConnector
installMysql
setupMysql
setupHive