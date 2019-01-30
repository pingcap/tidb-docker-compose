from pyspark.sql import SparkSession

spark = SparkSession.builder.master("spark://tispark-master:7077").appName("TiSpark tests").getOrCreate()

spark.sql("use TPCH_001")
 
count = spark.sql("select count(*) as c from lineitem").first()['c']

assert 60175 == count
