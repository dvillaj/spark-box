from pyspark import SparkConf, SparkContext

conf = SparkConf().setAppName("PySpark Lab") \
    .setMaster("spark://localhost:7077")

sc = SparkContext(conf=conf)