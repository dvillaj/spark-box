hdfs namenode -format

start-hadoop.sh

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod -R a+rw /user/hive