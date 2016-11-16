import pyspark
import aqaspark
sc = pyspark.SparkContext()
sqlContext = aqaspark.SQLContext(sc)
from datetime import datetime, time

# rdd = sc.textFile("/Users/kristianalexander/Documents/code/spark/edgar/master.20160513.idx.txt")
df_customer = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/customer.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")
df_orders = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/orders.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")
df_lineitem = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/lineitem.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")
df_supplier = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/supplier.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")
df_nation = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/nation.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")
df_region = sqlContext.read.parquet("https://aqa.blob.core.windows.net/assets/aqa/data/region.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D")


# create table from datafrom
df_customer.registerTempTable("customer")
df_orders.registerTempTable("orders")
df_lineitem.registerTempTable("lineitem")
df_supplier.registerTempTable("supplier")
df_nation.registerTempTable("nation")
df_region.registerTempTable("region")

benchmarks = []

# ========================
# RUN 1
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'AFRICA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 2
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'AMERICA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 3
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'ASIA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 4
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'EUROPE'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 5
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'MIDDLE EAST'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 6
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'AFRICA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 7
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'AMERICA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 8
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'ASIA'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 9
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'EUROPE'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


# ========================
# RUN 10
queryStartTime = datetime.now()
sqlContext.sql("""
    SELECT
    	n_name,
    	l_extendedprice * (1 - l_discount) as revenue
    FROM customer
    	INNER JOIN orders
    	  ON c_custkey = o_custkey
    	INNER JOIN lineitem
    	  ON l_orderkey = o_orderkey
    	INNER JOIN supplier
    	  ON l_suppkey = s_suppkey
    	INNER JOIN nation
    	  ON c_nationkey = s_nationkey
    	INNER JOIN region
    	  ON s_nationkey = n_nationkey
    	  AND n_regionkey = r_regionkey
    WHERE r_name = 'MIDDLE EAST'
""").show();
queryStopTime = datetime.now()
runTime = (queryStopTime-queryStartTime).seconds
print("Runtime: %s seconds" % (runTime))
benchmarks.append( runTime )


url = "https://aqa.blob.core.windows.net/public/googlecharter.html?data="
url += "["+ ",".join( str(run) for run in benchmarks) + "]"

print("-------- Query Finished. --------")
print("-------- Benchmark Results Viewer: %s --------" % url)
