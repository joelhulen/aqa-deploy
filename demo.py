import pyspark
import aqaspark
sc = pyspark.SparkContext()
sqlContext = aqaspark.SQLContext(sc)
from datetime import datetime, time

#rdd = sc.textFile("wasbs://public@aqa.blob.core.windows.net/data/test.txt")
df_customer = sqlContext.read.parquet("/data/data/customer.parquet")
df_orders = sqlContext.read.parquet("/data/data/orders.parquet")
df_lineitem = sqlContext.read.parquet("/data/data/lineitem.parquet")
df_supplier = sqlContext.read.parquet("/data/data/supplier.parquet")
df_nation = sqlContext.read.parquet("/data/data/nation.parquet")
df_region = sqlContext.read.parquet("/data/data/region.parquet")


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