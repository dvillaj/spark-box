from pyspark import SparkConf, SparkContext

import findspark
findspark.init()

conf = SparkConf().setAppName("PySpark Lab") \
    .setMaster("spark://localhost:7077")

sc = SparkContext(conf=conf)