-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 1. 집계 함수
-- MAGIC - 여러 행의 수치를 단 1개의 수치로 반환(즉, 여러 행들을 합쳐서 1개의 값을 반환)
-- MAGIC   - COUNT() : 여러 행의 수치의 총개수를 반환합니다.
-- MAGIC   - AVG() : 여러 행의 수치의 평균 값을 반환합니다.
-- MAGIC   - SUM() : 여러 행의 수치의 총 합을 반환합니다.
-- MAGIC   - MAX()와 MIN() : 여러 행의 수치 내에서 각각 최댓값과 최솟값을 반환합니다.

-- COMMAND ----------

-- DBTITLE 1,count(): 수량 계산 (해당 테이블의 전체 row 수 확인)
select count(*) from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,avg(): 평균
select avg(sal) as `평균연봉` from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,avg(): 평균 - round를 이용해서 소수점 조절
select round(avg(sal), 0) as `평균연봉` from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,max(): 최대값
select max(sal) as `최대연봉` from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,min(): 최소값
select min(sal) as `최소연봉` from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,sum(): 합계
select sum(sal) as `연봉합계` from dev.emp;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. 서브 쿼리
-- MAGIC - 서브 쿼리를 사용하면 서브쿼리 결과에 존재하는 데이터만 메인 쿼리에서 추출
-- MAGIC - IN, EXISTS 연산자 사용
-- MAGIC - 어느 부분을 메인, 어느 부분을 서브로 구성할지 판단해줘야 함
-- MAGIC - 최종 출력해줘야 하는게 메인 쿼리
-- MAGIC - 자료를 제공해주는게 서브 쿼리

-- COMMAND ----------

-- DBTITLE 0,서브쿼리 예제1
-- MAGIC %md
-- MAGIC ##### 서브쿼리 예제1
-- MAGIC - 질문: `평균 급여`보다 급여가 많은 사원이 소속된 `부서코드`와 `부서명` 조회.
-- MAGIC - 여기서 메인 쿼리는 `부서코드`와 `부서명`을 조회하는 것.(from 서브 쿼리)
-- MAGIC - `평균급여`보다 급여가 많은 `사원정보`를 출력해야하는게 서브 쿼리. (from emp 테이블)

-- COMMAND ----------

-- DBTITLE 1,Step 1) 평균 급여는?
select avg(sal)
from dev.emp;

-- COMMAND ----------

-- DBTITLE 1,Step2) 사원 테이블에서 평균급여보다 급여가 많은 사원은?
select empno, ename, sal
from dev.emp
where sal > (select avg(sal) from dev.emp)
order by sal;

-- COMMAND ----------

-- DBTITLE 1,Step3) 위 결과 내 사원이 소속된 부서 코드, 부서명 조회 in dept
select deptno as `부서코드`, dname as `부서명`
from dev.dept
where exists(


select *
from dev.emp
where sal > (select avg(sal) from dev.emp)
and dept.deptno = emp.deptno


);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 서브쿼리 예제2
-- MAGIC - 질문: 사번이 '7844'인 사원의 job 과 동일한 job 인 사원의 사번, 이름, job 을 출력
-- MAGIC - 사번이 '7844'인 사원의 job 과 동일한 job 인 사원의 사번, 이름, job 을 출력!
-- MAGIC - 메인 쿼리:  '서브쿼리'와 동일한 job을 가진 사원의 사번, 이름, job 을 출력
-- MAGIC - 서브 쿼리: 사번이 '7844'인 사원의 job

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 서브쿼리 예제3
-- MAGIC - 질문: 사번이 '7521' 인 사원의 job 과 동일하고 '7900' 인 사번의 급여보다 많은 급여를 받는 사원의 사번, 이름, job, 급여를 출력
-- MAGIC - 메인: 서브의 조건에 맞는 사원의 사번, 이름, job, 급여를 출력하라
-- MAGIC - 서브: 사번이 '7521' 인 사원의 job   +    '7900' 인 사번의 급여보다 많은 급여

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 서브쿼리 예제4
-- MAGIC - 질문: 가장 적은 급여를 받는 사원의 사번, 이름, 급여를 출력!
-- MAGIC - 메인: 사번, 이름, 급여를 출력!
-- MAGIC - 서브: 가장 적은 급여

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 서브쿼리 예제5
-- MAGIC - 질문: 부서별 최소 급여 중에서 30번 부서의 최소급여보다는 큰 최소급여인 부서의 부서번호, 최소 급여를 출력하라
-- MAGIC - 메인: 부서번호, 최소 급여
-- MAGIC - 서브: 부서별 최소 급여=having절, 30번 부서 최소급여 = 서브쿼리
-- MAGIC - having 사용해서 쿼리

-- COMMAND ----------



-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. CTEs (with절)
-- MAGIC - With절은 CTE(Common Table Expression)을 표현하는 구문
-- MAGIC - CTE는 기존의 뷰, 파생 테이블, 임시 테이블 등으로 사용되던 것을 대신할 수 있으며, 더 간결한 식으로 보여지는 장점이 있다.

-- COMMAND ----------

-- DBTITLE 1,2. CTEs(with절)
WITH t(x, y) AS (SELECT 1, 2)
  SELECT * FROM t WHERE x = 1 AND y = 2;

-- COMMAND ----------

-- DBTITLE 1,with절로 '총 연봉합이 많은 부서 순서로 정렬하자'
select * from dev.emp;          

-- COMMAND ----------

-- 우선 총연봉합 테이블을 with 절로 구한다.
select deptno, sum(sal)
from dev.emp
group by deptno;

-- COMMAND ----------

-- DBTITLE 1,CTE는 제일 아래행의 select문만 보면 된다. 해당 select문에 사용되는 테이블이 바로 with절에서 만든 테이블이다. (실존하지 않음)
-- 위 쿼리를 with절로 감싸고 다시 쿼리

with abc(
select deptno, sum(sal) as total_salary
from dev.emp
group by deptno
)
select * from abc order by total_salary;

-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4. Join문 (정규화 설명 포함)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC ### 4-1. 정규화란?
-- MAGIC - 목적: 중복된 데이터를 최대한 줄이기
-- MAGIC   - 보통 `최적화`라고 함(중복된 데이터는 관리도 어렵고, 불필요한 저장공간을 가지고 있으며, 연산결과도 느리게 만듬)
-- MAGIC - 따라서 중복된 데이터를 줄이려면 공통사항을 한 곳으로 모아놓고 필요에 따라서 연결시켜, 하나의 완전한 객체를 생성 = 정규화

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 4-2. Join문이란?
-- MAGIC ##### 개요
-- MAGIC - Join문을 이해하기 위해 샘플 테이블을 생성
-- MAGIC - 간단한 예제로 대표적인 4가지 Join문을 이해
-- MAGIC 
-- MAGIC ##### 4가지 목록
-- MAGIC 1. inner join
-- MAGIC 2. left (outer) join
-- MAGIC 3. right (outer) join
-- MAGIC 4. full (outer) join

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 1. Inner Join
-- MAGIC - 2개의 테이블에서 값이 일치하는 행을 반환.
-- MAGIC - 즉, 교집합

-- COMMAND ----------

-- DBTITLE 1,조건문(deptno가 같은 것)에 기반하여 두 테이블 모두에 충족하는 값(deptno 1,2,3)만 출력
SELECT id, name, employee.deptno, deptname
FROM employee
INNER JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,Inner Join이 default값이기 때문에 join만 입력해도 무방
SELECT id, name, employee.deptno, deptname
FROM employee
JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,예제1: 같은 도시에 거주하는 sales_id와 customer_id 찾기(출력은 salesman 테이블의 name, customer 테이블의 cust_name, city)


-- COMMAND ----------

-- DBTITLE 1,예제2: 주문 금액이 500에서 2000사이에 있는 주문 찾기 (출력은 orders 테이블의 ord_no, purch_amt, customer 테이블의 cust_name, city)


-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### Outer Join
-- MAGIC - 두 테이블에서 지정된 쪽인 Left 또는 Right 쪽의 모든 결과를 보여줍니다.
-- MAGIC - 반대쪽에 매칭되는 값이 없어도 보여주는 Join
-- MAGIC - 쉽게 말해서 쿼리 내 Join문 기준, Join 이전에 나오는 테이블이 왼쪽(Left)가 되고, Join 이후에 나오는 테이블은 오른쪽(Right)이 됩니다.
-- MAGIC 
-- MAGIC ##### 2. Left Outer Join
-- MAGIC - 좌측을 기준으로 합니다.
-- MAGIC - 예를 들어, `...FROM A LEFT JOIN B...`인 경우, 왼쪽에 있는 A의 모든 값을 다 보여주면서(A데이터 범위 안에 한정) 이에 매치되는 B까지 함께 보여줌.

-- COMMAND ----------

-- DBTITLE 1,Employee 기준으로 Left Join 수행(6개의 행을 가진 employee를 기준으로 이에 매치되는 department까지 출력. 없는 값은 null.)
use megazone;
SELECT id, name, employee.deptno, deptname
FROM employee
LEFT JOIN department 
ON employee.deptno = department.deptno;

-- COMMAND ----------

select * from department

-- COMMAND ----------

use megazone;
SELECT id, name, department.deptno, deptname
FROM department
LEFT JOIN employee 
ON department.deptno = employee.deptno;

-- COMMAND ----------

-- DBTITLE 1,예제: A, B 테이블 중에서 A값의 전체와 A의 key와 B의 key가 같은 결과 리턴


-- COMMAND ----------

-- DBTITLE 1,예제


-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3. Right (Outer) Join
-- MAGIC - 우측을 기준으로 합니다.
-- MAGIC - 예를 들어, `...FROM A LEFT JOIN B...`인 경우, 오른쪽에 있는 B의 모든 값을 다 보여주면서(B데이터 범위 안에 한정) 이에 매치되는 A까지 함께 보여줌.

-- COMMAND ----------

-- DBTITLE 1,department 기준으로 Right Join 수행(4개의 행을 가진 department 를 기준으로 이에 매치되는 employee까지 출력. 없는 값은 null.)
SELECT id, name, employee.deptno, deptname
FROM employee
RIGHT JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,예제


-- COMMAND ----------



-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 4. Full (Outer) Join
-- MAGIC - 일종의 합집합으로 이해하면 쉬움

-- COMMAND ----------

-- DBTITLE 1,조건으로 건 deptno의 고유값 개수만큼 행이 출력됨. (이때 기준은 왼쪽이므로, employee에 없는 deptno는 null)
SELECT id, name, employee.deptno, deptname
FROM employee
FULL JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,출력 deptno에 따라 값이 바뀜.
SELECT id, name, department.deptno, deptname
FROM employee
FULL JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,예제


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 5. Window 함수
-- MAGIC - window 함수 개요
-- MAGIC - 행과 행간의 관계를 쉽게 정의하는게 목적.
-- MAGIC   - Ranking 함수
-- MAGIC   - Analytic 함수
-- MAGIC   - Aggregate 함수

-- COMMAND ----------

-- DBTITLE 1,5-1-1. Ranking 함수(rank())
-- 그룹 내 순위 함수
-- SELECT rank()(value_expr) OVER (PARTITION BY window_partition ORDER BY window_ordering) from table

-- 특정 범위는 partition by로 한정시킬 수 있음.
-- order by로 순위 매길 대상 선정
-- 여러개이면 상위가 기준

select name, dept, salary,
rank() over(order by salary) as `전체 순위`,
rank() over (partition by dept order by salary) as `부서내 순위`
from emp;

-- COMMAND ----------

-- 이건 dept 기준 정렬(dept 내 salary로 정렬)


select name, dept, salary,
-- rank() over(order by salary) as `전체 순위`,
rank() over (partition by dept order by salary) as `부서내 순위`
from emp;

-- COMMAND ----------

select * from emp;

-- COMMAND ----------

-- DBTITLE 1,5-1-2. Ranking 함수(dense_rank())
-- 순위매기는 다른 방법
-- rank는 1,2,2,2,5로 등수를 매기지만
-- dense_rank는 1,2,2,2,3으로 순위를 매긴다.

select name,
rank() over (order by salary) as ranks,
dense_rank() over (order by salary) as dens_ranks
from emp;

-- COMMAND ----------

-- DBTITLE 1,5-1-3. Ranking 함수(row_number())
-- 순위매기는 다른 방법
-- rank는 1,2,2,2,5로 등수를 매기지만
-- dense_rank는 1,2,2,2,3으로 순위를 매기지만
-- row_number은 1,2,3,4,5등으로 순위를 매긴다. (동일한 salary의 경우, 정렬 순서에 따라 순위 바뀜)
-- 이 순위 기준은 없음.

select name,
rank() over (order by salary) as ranks,
dense_rank() over (order by salary) as dens_ranks,
row_number() over (order by salary) as row_number_ranks
from emp
order by ranks, name
;

-- COMMAND ----------

select *,
rank() over (partition by dept order by salary) as ranks,
dense_rank() over (partition by dept order by salary) as dens_ranks,
row_number() over (partition by dept order by salary) as row_number_ranks
from emp
order by dept, salary, name;

-- COMMAND ----------

-- https://velog.io/@ena_hong/SQL-Analytic-Function-%EB%B6%84%EC%84%9D%ED%95%A8%EC%88%98

-- COMMAND ----------



-- COMMAND ----------

-- DBTITLE 1,5-2-1. Analytic 함수(lead()) 
-- MAGIC %md
-- MAGIC - lead: 후행 로우값.
-- MAGIC   - 현재 행 뒤에 있는 행의 값을 반환
-- MAGIC - lag

-- COMMAND ----------

-- lead(expr [, offset [, default] ] )
-- 문서를 보시면 다음처럼 되어 있다.

-- expr, offset, default가 뭔지 예제를 통해 확인해보자.

-- COMMAND ----------

-- 부서별(partition by) age순으로 정렬(order by)으로 출력된 후행 salary값 출력.
-- (현재 행 다음 행을 출력)

select *,
lead(salary) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

select *,
lead(salary, 1) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

-- 2행후 값 가져오기

select *,
lead(salary, 2) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

select *,
lead(salary, 2, 99999) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

select name, dept, salary-lead_salary as improved_salary
from
(
select *,
lead(salary) over (partition by dept order by age) as lead_salary
from emp
);

-- COMMAND ----------



-- COMMAND ----------



-- COMMAND ----------

-- DBTITLE 1,5-2-1. Analytic 함수(LAG()) - lead와 동일하게 작동하지만 후행이 아닌 선행
select *,
lag(salary) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

select *,
lag(salary, 2) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------

select *,
lag(salary, 2, 0) over (partition by dept order by age) as lead_salary
from emp;

-- COMMAND ----------



-- COMMAND ----------

-- DBTITLE 1,5-3. aggregation 함수
-- MAGIC %md
-- MAGIC - sum
-- MAGIC - min
-- MAGIC - max
-- MAGIC - avg
-- MAGIC - count
-- MAGIC 
-- MAGIC ### 비교
-- MAGIC - 그냥 집계 함수
-- MAGIC   - 여러 행의 수치를 단 1개의 수치로 반환(즉, 여러 행들을 합쳐서 1개의 값을 반환)
-- MAGIC   - AVG() : 여러 행의 수치의 평균 값을 반환합니다.
-- MAGIC   - SUM() : 여러 행의 수치의 총 합을 반환합니다.
-- MAGIC   - MAX()와 MIN() : 여러 행의 수치 내에서 각각 최댓값과 최솟값을 반환합니다.
-- MAGIC   - COUNT() : 여러 행의 수치의 총개수를 반환합니다. 
-- MAGIC   
-- MAGIC 
-- MAGIC - 윈도우 함수 내 집계함수
-- MAGIC   - 윈도우 창(window frame)을 기준으로 실행.
-- MAGIC   - 각 행마다 1개의 값을 반환함.(차이점 *****) 즉, 행의 개수의 변화 유무가 차이점
-- MAGIC   - 실행을 위해 over()구문이 필요함.(partition by는 마치 group by 역할을 함.)
-- MAGIC   - 기존 데이터에는 아무런 변화를 주지 않은 상태에서 새로운 열에 반환할 값을 계산하고자 집계 함수를 '함께' 씀
-- MAGIC   - 예를 들어, 내 테이블에 새로운 열을 추가 하고 싶음.
-- MAGIC   - 이 열에는 도시별 일별 평균 거래액을 넣고 싶음.

-- COMMAND ----------

-- https://velog.io/@ena_hong/SQL-Analytic-Function-%EB%B6%84%EC%84%9D%ED%95%A8%EC%88%98

-- COMMAND ----------

select * 
from transactions
order by id
;

-- COMMAND ----------

-- 원래 10행이었으나 -> 8행으로 줄어듬 (group by로 묶으면서 1순위인 dates를 기준으로 중복 제거됨)
-- 

-- 날짜별, 도시별 평균 amount를 보고 싶다면???
-- 그냥 집계 함수 사용 시

select dates, city, avg(amount) as avg_amount
from transactions
group by dates, city
order by city, dates;

-- COMMAND ----------

-- 윈도우 함수의 경우 10행이 그대로 살아있음.
-- https://kimsyoung.tistory.com/entry/SQL-%EB%82%B4-%EC%A7%91%EA%B3%84-%ED%95%A8%EC%88%98-vs-%EC%9C%88%EB%8F%84%EC%9A%B0-%ED%95%A8%EC%88%98-%EC%9C%A0%EC%82%AC%EC%A0%90%EA%B3%BC-%EC%B0%A8%EC%9D%B4%EC%A0%90

select id, dates, city, amount,
-- 변형(아래 group by값을 partition by에 추가)
avg(amount) over(partition by dates, city order by amount) as avg_amount_daily
from transactions
-- group by dates, city
;
