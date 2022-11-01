# Databricks notebook source
# MAGIC %python
# MAGIC 
# MAGIC try:
# MAGIC   dbutils.fs.unmount("/mnt/temp-training")
# MAGIC except:
# MAGIC   pass # ignored
# MAGIC 
# MAGIC spark.sql("DROP DATABASE IF EXISTS junk CASCADE")
# MAGIC spark.sql("DROP DATABASE IF EXISTS databricks CASCADE")
# MAGIC 
# MAGIC classroomCleanup(daLogger, courseType, username, moduleName, lessonName, True)

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC DROP VIEW IF EXISTS employee;
# MAGIC DROP VIEW IF EXISTS department;

# COMMAND ----------

# MAGIC %python
# MAGIC showStudentSurvey()
