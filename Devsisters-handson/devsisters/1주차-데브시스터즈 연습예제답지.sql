-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 사용할 테이블
-- MAGIC - 테이블명: aac_intakes, aac_outcomes
-- MAGIC - 해당 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블 입니다.
-- MAGIC - 테이블 구조는 아래와 같습니다. (테이블은 모든 데이터베이스에 담아두었습니다.)
-- MAGIC 
-- MAGIC 
-- MAGIC ### 테이블 컬럼 설명
-- MAGIC - ANIMAL_ID : 동물의 아이디
-- MAGIC - ANIMAL_TYPE : 생물종
-- MAGIC - DATETIME : 보호 시작일
-- MAGIC - INTAKE_CONDITION : 보호 시작 시 상태
-- MAGIC - NAME : 이름
-- MAGIC - SEX_UPON_INTAKE : 성별 및 중성화 여부

-- COMMAND ----------

show tables

-- COMMAND ----------

desc table megazone.aac_intakes;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 1. 동물 보호소에 들어온 모든 동물의 정보를 animal_id순으로 조회하기

-- COMMAND ----------

-- DBTITLE 0,1. 동물 보호소에 들어온 모든 동물의 정보를 animal_id
select * from aac_intakes
order by animal_id;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 2. 동물 보호소에 들어온 모든 동물의 이름과 보호 시작일을 조회하기
-- MAGIC - 이때 결과는 ANIMAL_ID 역순

-- COMMAND ----------

select name, datetime
from aac_intakes
order by animal_id desc;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3. 동물 보호소에 들어온 동물 중 아픈 동물의 아이디 조회하기
-- MAGIC - 아픔은 intake_condition 컬럼의 Sick

-- COMMAND ----------

select distinct(intake_condition) from megazone.aac_intakes;

-- COMMAND ----------

select ANIMAL_ID, ANIMAL_TYPE, intake_condition from megazone.aac_intakes
where INTAKE_CONDITION = 'Sick';

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 4. 동물 보호소에 들어온 동물 중 동물이 보호소에 가장 많이 들어온 연도

-- COMMAND ----------

select year(datetime) as year, count(*) as cnt 
from megazone.aac_intakes
group by(year(datetime))
order by count(*) desc

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 5. 동물 보호소에 들어온 동물 중 고양이와 개가 각각 몇마리씩 있는가

-- COMMAND ----------

select animal_type, count(animal_type) as count
from megazone.aac_intakes
group by animal_type
having animal_type = 'Cat' or animal_type ='Dog';

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 6. 동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회
-- MAGIC - 이름이 없는 동물은 집계에서 제외하며, 결과는 횟수 내림차순으로 조회
-- MAGIC - 가장 많은 중복 이름을 가진 동물 찾기

-- COMMAND ----------

select count(name)
from megazone.aac_intakes

-- COMMAND ----------

select count(name)
from megazone.aac_intakes
where name is null

-- COMMAND ----------

select name, count(name) as cnt 
from megazone.aac_intakes
group by name

-- COMMAND ----------

select name, count(*) as cnt from megazone.aac_intakes
where not name is Null
group by name
having cnt > 1
order by cnt desc 
limit 1;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 7. 보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 
-- MAGIC - 09:00부터 19:59까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회
-- MAGIC - 이때 결과는 시간대가 많은 순으로 정렬
-- MAGIC - aac_outcomes 테이블 사용

-- COMMAND ----------

select hour(datetime) as hour, count(*) as cnt
from megazone.aac_outcomes
where hour(datetime) >= 9 and hour(datetime) < 20
group by hour(datetime)
order by cnt desc
;

-- COMMAND ----------


