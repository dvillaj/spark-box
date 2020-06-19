from pyspark import SparkContext, SparkConf, SQLContext

appName = "PySpark SQL Server Example - via JDBC"
master = "spark://localhost:7077"
conf = SparkConf() \
    .set('spark.sql.catalogImplementation', 'hive') \
    .setAppName(appName) \
    .setMaster(master)

sc = SparkContext(conf=conf)

from pyspark.sql import HiveContext
hc = HiveContext(sc)

hc.sql("show tables").show()
hc.sql("select * from test_table").show()