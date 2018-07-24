from pyspark.sql import SparkSession
import pytispark.pytispark as pti

spark = SparkSession.builder.master("spark://tispark-master:7077").appName("TiSpark tests").getOrCreate()

ti = pti.TiContext(spark)
 
ti.tidbMapDatabase("TPCH_001")
 
count = spark.sql("select count(*) as c from lineitem").first()['c']

assert 60175 == count
