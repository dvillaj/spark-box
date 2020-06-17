import os
import sys

# The place where CDH installed spark, if the user installed Spark locally it can be changed here.
# Optionally we can check if the variable can be retrieved from environment.

os.environ["SPARK_HOME"] = "/opt/spark"
os.environ["PYSPARK_PYTHON"] = "/usr/bin/python3"

# And Python path
os.environ["PYLIB"] = os.environ["SPARK_HOME"] + "/python/lib"
sys.path.insert(0, os.environ["PYLIB"] +"/py4j-0.10.7-src.zip")
sys.path.insert(0, os.environ["PYLIB"] +"/pyspark.zip")

os.environ["PYSPARK_SUBMIT_ARGS"] = "--name yarn pyspark-lab"

import pyspark
sc = pyspark.SparkContext('spark://localhost:7077')

