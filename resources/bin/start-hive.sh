hive --service hiveserver2  > /opt/hive/logs/hive2.log 2>&1 &
hive --service metastore  > /opt/hive/logs/metastore.log 2>&1 &