schematool --verbose -dbType mysql -initSchema

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod -R a+rw /user/hive