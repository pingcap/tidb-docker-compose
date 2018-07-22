# How To Spin Up an HTAP Database in 5 Minutes with TiDB + TiSpark

## Tesed On
* GNU/Linux Debian Stretch with 3.3GB of RAM and Core i3
* Docker Community Edition >= 18.06.0-ce
* Docker Compose >= 1.8.0

[TiDB](http://bit.ly/tidb_repo_publication) is an open-source distributed Hybrid Transactional and Analytical Processing (HTAP) database built by PingCAP, powering companies to do real-time data analytics on live transactional data in the same data warehouse – no more ETL, no more T+1, no more delays. More than 200 companies are now using TiDB in production. Its 2.0 version was launched in late April 2018 (read about it in this [ this blog post](http://bit.ly/tidb_2_0) ).

In this 5-minute tutorial, we will show you how to spin up a standard TiDB cluster using Docker Compose on your local computer, so you can get a taste of its hybrid power, before using it for work or your own project in production. A standard TiDB cluster includes TiDB (MySQL compatible stateless SQL layer), [TiKV](http://bit.ly/tikv_repo_publication) (a distributed transactional key-value store where the data is stored), and [TiSpark](https://github.com/pingcap/tispark) (an Apache Spark plug-in that powers complex analytical queries within the TiDB ecosystem).

    NOTE: This guide is for Linux users!

Ready? Let’s get started!

## Setting Up
Before we start deploying TiDB, we’ll need a few things first: `apt` (or the package manager installed by your official Linux ditribution), `wget`, `Git`, `Docker`, and a `MySQL` client. If you don’t have them installed already, here are the instructions to get them. Replace `apt` with the name of the package manager of your Linux distribution if you are not using Debian, Ubuntu or their derivatives.

1. To install `wget`.
    ```
    $ apt install wget
    ```
2. To install `git`
    ```
    $ apt install git
    ```
3. Install Docker Community Edition: https://www.docker.com/community-edition

4. Install MySQL client
    ```
    $ apt install mysql-client
    ```

## Spin up a TiDB cluster
Now that Docker is set up, let’s deploy TiDB!
1. Clone TiDB Docker Compose onto your laptop:
    ```
    $ git clone https://github.com/pingcap/tidb-docker-compose
    ```
2. Optionally, you can use `docker-compose` pull to get the latest Docker images.
3. Change your directory to `tidb-docker-compose`:
 ```$ cd tidb-docker-compose
 ```
4. Deploy TiDB on your laptop:
 ```docker-compose up -d
 ```
You can see messages in your terminal launching the default components of a TiDB cluster: 1 TiDB instance, 3 TiKV instances, 3 Placement Driver (PD) instances, Prometheus, Grafana, 2 TiSpark instances (one master, one slave), and a TiDB-Vision instance.

**_Congratulations! You have just deployed a TiDB cluster on your laptop!_**

To check if your deployment is successful:
* Go to: `http://localhost:3000` to launch Grafana with default user/password: admin/admin.
  * Go to `Home` and click on the pull down menu to see dashboards of different TiDB components: TiDB, TiKV, PD, entire cluster.
  * You will see a dashboard full of panels and stats on your current TiDB cluster. Feel free to play around in Grafana, e.g. `TiDB-Cluster-TiKV`, or `TiDB-Cluster-PD`.

* Now go to TiDB-vision at http://localhost:8010 (TiDB-vision is a cluster visualization tool to see data transfer and load-balancing inside your cluster).

 * You can see a ring of 3 [TiKV](http://bit.ly/tikv_repo_publication) nodes. TiKV applies the Raft consensus protocol to provide strong consistency and high availability. Light grey blocks are empty spaces, dark grey blocks are Raft followers, and dark green blocks are Raft leaders. If you see flashing green bands, that represent communications between TiKV nodes.

## Test TiDB compatibility with MySQL
As we mentioned, TiDB is MySQL compatible. You can use TiDB as MySQL slaves with instant horizontal scalability. That’s how many innovative tech companies, like [Mobike](https://www.pingcap.com/blog/Use-Case-TiDB-in-Mobike/), use TiDB.

To test out this MySQL compatibility:

1. Keep the tidb-docker-compose running, and launch a new Terminal tab or window.

2. Add MySQL to the path (if you haven’t already):

    ```export PATH=${PATH}:/usr/local/mysql/bin```

3. Launch a MySQL client that connects to TiDB:

    ```mysql -h 127.0.0.1 -P 4000  -u root```

**_Result_**: You will see the following message, which shows that TiDB is indeed connected to your MySQL instance:

**_Note_**: TiDB version number may be different.

```Server version: 5.7.10-TiDB-v2.0.0-rc.4-31```

## Let’s get some data!
Now we will grab some sample data that we can play around with.
1. Open a new Terminal tab or window and download the `tispark-sample-data.tar.gz` file.

    ```$ wget http://download.pingcap.org/tispark-sample-data.tar.gz```
2. Unzip the sample file:

    ```$ tar zxvf tispark-sample-data.tar.gz```
3. Inject the sample test data from sample data folder to MySQL:
    ```$ mysql --local-infile=1 -u root -h 127.0.0.1 -P 4000 < tispark-sample-data/dss.ddl```
    
   This will take a few seconds.
4. Go back to your MySQL client window or tab, and see what’s in there:
    ```SHOW DATABASES;```
    **Result**: You can see the `TPCH_001` database on the list. That’s the sample data we just ported over.
    
    Now let’s go into `TPCH_001`:
    ```
    USE TPCH_001;
    SHOW TABLES;
    ```
    **Result**: You can see all the tables in `TPCH_001`, like `NATION`, `ORDERS`, etc.

5. Let’s see what’s in the `NATION` table:

    `SELECT * FROM NATION;`
    
**Result**: You’ll see a list of countries with some keys and comments.

## Launch TiSpark

Now let’s launch TiSpark, the last missing piece of our hybrid database puzzle.

1. In the same window where you downloaded TiSpark sample data (or open a new tab), go back to the tidb-docker-compose directory.

2. Launch Spark within TiDB with the following command:
    
    ```docker-compose exec tispark-master  /opt/spark-2.1.1-bin-hadoop2.7/bin/spark-shell```
    This will take a few minutes. 
    **Result**: Now you can Spark! Now you can Spark

    ```
    Welcome to
          ____              __
         / __/__  ___ _____/ /__
        _\ \/ _ \/ _ `/ __/  '_/
       /___/ .__/\_,_/_/ /_/\_\   version 2.1.1
          /_/

    Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_172)
    Type in expressions to have them evaluated.
    Type :help for more information.
    ```

3. Use the following three commands, one by one, to bind TiSpark to this Spark instance and map to the database TPCH_001, the same sample data that’s available in our MySQL instance:

    ```
    import org.apache.spark.sql.TiContext
    val ti = new TiContext(spark)
    ti.tidbMapDatabase("TPCH_001")
    ```
4. Now, let’s see what’s in the `NATION` table (should be the same as what we saw on our MySQL client):

    ```spark.sql("select * from nation").show(30);```

## Let’s get hybrid!
Now, let’s go back to the MySQL tab or window, make some changes to our tables, and see if the changes show up on the TiSpark side.

1. In the MySQL client, try this UPDATE:

    ```UPDATE NATION SET N_NATIONKEY=444 WHERE N_NAME="CANADA";
    SELECT * FROM NATION; ```

2. Then see if the update worked:

    ```SELECT * FROM NATION;```

3. Now go to the TiSpark Terminal window, and see if you can see the same update:

    ```spark.sql("select * from nation").show(30);```

    **Result**: The UPDATE you made on the MySQL side shows up immediately in TiSpark!
    
-You can see that both the MySQL and TiSpark clients return the same results – fresh data for you to do analytics on right away. Voila!

## Summary
With this simple deployment of TiDB on your local machine, you now have a functioning Hybrid Transactional and Analytical processing (HTAP) database. You can continue to make changes to the data in your MySQL client (simulating transactional workloads) and analyze the data with those changes in TiSpark (simulating real-time analytics).

Of course, launching TiDB on your local machine is purely for experimental purposes. If you are interested in trying out TiDB for your production environment, send us a note: `info@pingcap.com` or reach out on our [website](https://www.pingcap.com/en/). We’d be happy to help you!