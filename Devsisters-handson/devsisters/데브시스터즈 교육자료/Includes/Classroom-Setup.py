# Databricks notebook source
spark.conf.set("com.databricks.training.module-name", "summit-sql")

courseAdvertisements = dict()

spark.conf.set("com.databricks.training.suppress.untilStreamIsReady", "true")
spark.conf.set("com.databricks.training.suppress.stopAllStreams", "true")
spark.conf.set("com.databricks.training.suppress.moduleName", "true")
spark.conf.set("com.databricks.training.suppress.lessonName", "true")
spark.conf.set("com.databricks.training.suppress.username", "true")
spark.conf.set("com.databricks.training.suppress.userhome", "true")
spark.conf.set("com.databricks.training.suppress.workingDir", "true")

displayHTML("Preparing learning environment...")


# COMMAND ----------

# MAGIC %run "./Common-Notebooks/Common"

# COMMAND ----------


def createTableFrom(tableName, filesPath):
  spark.sql(f"""CREATE TABLE IF NOT EXISTS {tableName} USING parquet OPTIONS (path "{filesPath}")""");
  spark.sql(f"uncache TABLE {tableName}")
  # print(f"""Created the table {tableName} from {filesPath}""")

createTableFrom("People10M", "dbfs:/mnt/training/dataframes/people-10m.parquet")
createTableFrom("SSANames", "dbfs:/mnt/training/ssn/names.parquet")

try:
  dbutils.fs.unmount("/mnt/temp-training")
except:
  pass # ignored

allDone(courseAdvertisements)

# COMMAND ----------

# MAGIC %sql
# MAGIC DROP VIEW IF EXISTS employee;
# MAGIC DROP VIEW IF EXISTS department;
# MAGIC 
# MAGIC 
# MAGIC CREATE TEMPORARY VIEW employee(id, name, deptno) AS
# MAGIC      VALUES(105, 'Chloe', 5),
# MAGIC            (103, 'Paul' , 3),
# MAGIC            (101, 'John' , 1),
# MAGIC            (102, 'Lisa' , 2),
# MAGIC            (104, 'Evan' , 4),
# MAGIC            (106, 'Amy'  , 6);
# MAGIC 
# MAGIC CREATE TEMPORARY VIEW department(deptno, deptname) AS
# MAGIC     VALUES(8, 'CEO'),
# MAGIC           (7, 'Engineering'),
# MAGIC           (2, 'Sales'      ),
# MAGIC           (1, 'Marketing'  );

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE TABLE emp
# MAGIC    (name STRING, dept STRING, salary INT, age INT);
# MAGIC    
# MAGIC INSERT INTO emp
# MAGIC    VALUES ('Lisa', 'Sales', 10000, 35),
# MAGIC           ('Evan', 'Sales', 32000, 38),
# MAGIC           ('Fred', 'Engineering', 21000, 28),
# MAGIC           ('Alex', 'Sales', 30000, 33),
# MAGIC           ('Tom', 'Engineering', 23000, 33),
# MAGIC           ('Jane', 'Marketing', 29000, 28),
# MAGIC           ('Jeff', 'Marketing', 35000, 38),
# MAGIC           ('Paul', 'Engineering', 29000, 23),
# MAGIC           ('Chloe', 'Engineering', 23000, 25);

# COMMAND ----------

# MAGIC %sql
# MAGIC drop table if exists transactions;
# MAGIC CREATE TABLE if not exists transactions
# MAGIC    (id int, dates date, city STRING, amount float);
# MAGIC    
# MAGIC INSERT INTO transactions
# MAGIC    VALUES (1, '2020-11-01', 'San Francisco', 420.65),
# MAGIC           (2, '2020-11-01', 'New York', 1129.85),
# MAGIC           (3, '2020-11-02', 'San Francisco', 2213.25),
# MAGIC           (4, '2020-11-02', 'New York', 499.00),
# MAGIC           (5, '2020-11-02', 'New York', 980.30),
# MAGIC           (6, '2020-11-03', 'San Francisco', 872.60),
# MAGIC           (7, '2020-11-03', 'San Francisco', 3452.25),
# MAGIC           (8, '2020-11-03', 'New York', 563.35),
# MAGIC           (9, '2020-11-04', 'New York', 1843.10),
# MAGIC           (10, '2020-11-04', 'San Francisco', 1705.00);

# COMMAND ----------

# MAGIC %sql
# MAGIC use sslee_megazone_com_summit_sql_1_sql_pil;
# MAGIC 
# MAGIC DROP TABLE IF EXISTS dept;
# MAGIC DROP TABLE IF EXISTS salgrade;
# MAGIC DROP TABLE IF EXISTS emp;
# MAGIC 
# MAGIC CREATE TABLE salgrade
# MAGIC (
# MAGIC grade int not null,
# MAGIC losal int,
# MAGIC hisal int
# MAGIC );
# MAGIC 
# MAGIC CREATE TABLE dept
# MAGIC (
# MAGIC deptno int not null,
# MAGIC dname string not null,
# MAGIC location string not null
# MAGIC );
# MAGIC 
# MAGIC CREATE TABLE emp
# MAGIC (
# MAGIC empno int not null,
# MAGIC ename string not null,
# MAGIC job string not null,
# MAGIC mgr int,
# MAGIC sal int,
# MAGIC comm int,
# MAGIC deptno int not null
# MAGIC );
# MAGIC 
# MAGIC insert into dept values (10,'Accounting','New York');
# MAGIC 
# MAGIC insert into dept values (20,'Research','Dallas');
# MAGIC 
# MAGIC insert into dept values (30,'Sales','Chicago');
# MAGIC 
# MAGIC insert into dept values (40,'Operations','Boston');
# MAGIC 
# MAGIC 
# MAGIC 
# MAGIC insert into emp values (7369,'SMITH','CLERK',7902,800,0.00,20);
# MAGIC 
# MAGIC insert into emp values (7499,'ALLEN','SALESMAN',7698,1600,300,30);
# MAGIC 
# MAGIC insert into emp values (7521,'WARD','SALESMAN',7698,1250,500,30);
# MAGIC 
# MAGIC insert into emp values (7566,'JONES','MANAGER',7839,2975,null,20);
# MAGIC 
# MAGIC insert into emp values (7698,'BLAKE','MANAGER',7839,2850,null,30);
# MAGIC 
# MAGIC insert into emp values (7782,'CLARK','MANAGER',7839,2450,null,10);
# MAGIC 
# MAGIC insert into emp values (7788,'SCOTT','ANALYST',7566,3000,null,20);
# MAGIC 
# MAGIC insert into emp values (7839,'KING','PRESIDENT',null,5000,0,10);
# MAGIC 
# MAGIC insert into emp values (7844,'TURNER','SALESMAN',7698,1500,0,30);
# MAGIC 
# MAGIC insert into emp values (7876,'ADAMS','CLERK',7788,1100,null,20);
# MAGIC 
# MAGIC insert into emp values (7900,'JAMES','CLERK',7698,950,null,30);
# MAGIC 
# MAGIC insert into emp values (7934,'MILLER','CLERK',7782,1300,null,10);
# MAGIC 
# MAGIC insert into emp values (7902,'FORD','ANALYST',7566,3000,null,20);
# MAGIC 
# MAGIC insert into emp values (7654,'MARTIN','SALESMAN',7698,1250,1400,30);
# MAGIC 
# MAGIC 
# MAGIC insert into salgrade values (1,700,1200);
# MAGIC 
# MAGIC insert into salgrade values (2,1201,1400);
# MAGIC 
# MAGIC insert into salgrade values (3,1401,2000);
# MAGIC 
# MAGIC insert into salgrade values (4,2001,3000);
# MAGIC 
# MAGIC insert into salgrade values (5,3001,99999);
