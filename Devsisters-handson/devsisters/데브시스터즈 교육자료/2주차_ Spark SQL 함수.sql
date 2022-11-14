-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### 1. 집계 함수
-- MAGIC - 여러 행의 수치를 단 1개의 수치로 반환(즉, 여러 행들을 합쳐서 1개의 값을 반환)
-- MAGIC   - COUNT() : 여러 행의 수치의 총개수를 반환합니다.
-- MAGIC   - AVG() : 여러 행의 수치의 평균 값을 반환합니다.
-- MAGIC   - SUM() : 여러 행의 수치의 총 합을 반환합니다.
-- MAGIC   - MAX()와 MIN() : 여러 행의 수치 내에서 각각 최댓값과 최솟값을 반환합니다.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - select `count(카운트할 컬럼)` from `테이블`

-- COMMAND ----------

-- DBTITLE 1,count(): 수량 계산 (해당 테이블의 전체 row 수 확인)
select count(*) from megazone.emp;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - select avg `(카운트할 컬럼)` from `테이블`
-- MAGIC 
-- MAGIC - 만약 avg가 소수점으로 나왔는데, 소수점 보여주기 싫으면?
-- MAGIC - select `round(avg(카운트할 컬럼), 0)` from `테이블`          -> (이때, 0의 의미는 0의 자리까지 보여주겠다는 의미)

-- COMMAND ----------

-- DBTITLE 1,avg(): 평균 - round를 이용해서 소수점 조절
select round(avg(sal), 0) as `평균연봉` from megazone.emp;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - select `max(카운트할 컬럼)` from `테이블`

-- COMMAND ----------

-- DBTITLE 1,max(): 최대값
select max(sal) as `최대연봉` from megazone.emp;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - select `min(카운트할 컬럼)` from `테이블`

-- COMMAND ----------

-- DBTITLE 1,min(): 최소값
select min(sal) as `최소연봉` from megazone.emp;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - select `sum(카운트할 컬럼)` from `테이블`

-- COMMAND ----------

-- DBTITLE 1,sum(): 합계
select sum(sal) as `연봉합계` from megazone.emp;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. CTEs (with절)
-- MAGIC - With절은 CTE(Common Table Expression)을 표현하는 구문
-- MAGIC - CTE는 기존의 뷰, 파생 테이블, 임시 테이블 등으로 사용되던 것을 대신할 수 있으며, 더 간결한 식으로 보여지는 장점이 있다.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 지난주에 했던 서브쿼리에 '이름'을 붙이는 것이라고 생각하면 됩니다.
-- MAGIC 
-- MAGIC - view, table는 만들어두면 drop할 때까지 없어지지 않지만
-- MAGIC - with절은 이 쿼리문이 돌아가는 하나의 cmd 안에서만 살아있고 없어짐.(이 안에서만 실행됨)
-- MAGIC 
-- MAGIC ### 사용하는 이유
-- MAGIC - with절은 복잡한 sql에서 '같은 쿼리문'이 '반복적으로 sql문을 사용되는 경우', 이 쿼리문에 이름을 붙여서 재사용하게 해줌. (쿼리의 길이를 줄여줌)

-- COMMAND ----------

-- with 'with절에 붙일 이름' as (

-- select * from 대상 테이블   <---- 괄호 안에는 내가 사용할 서브쿼리문 입력
-- where 

-- )
-- select * from 'with절에 붙일 이름';

-- COMMAND ----------

-- DBTITLE 1,예제1) 그냥 where이 있는 쿼리문
select * from megazone.emp
where empno = 7844;

-- COMMAND ----------

-- DBTITLE 1,예제1) with절로 해보는 쿼리문
with temptable(
select * from megazone.emp
where empno = 7844
)
select * from temptable;

-- COMMAND ----------

-- DBTITLE 1,예제2) with절로 '총 연봉합이 많은 부서 순서로 정렬하자'
-- 우선 총연봉합 테이블을 with 절로 구한다.
select deptno, sum(sal) as `총연봉합`
from megazone.emp
group by deptno
order by `총연봉합` desc;

-- COMMAND ----------

-- DBTITLE 1,예제2) CTE는 제일 아래행의 select문만 보면 된다. 해당 select문에 사용되는 테이블이 바로 with절에서 만든 테이블이다. (실존하지 않음)
with SAMPLE (
select deptno, sum(sal) as `총연봉합`
from megazone.emp
group by deptno
order by `총연봉합` desc
)
select * from SAMPLE;

-- COMMAND ----------

-- DBTITLE 1,예제2) 위에서 사용한 with절은 별도로 쿼리날리면 실패함.
-- select * from SAMPLE;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3. Join문 (정규화 설명 포함)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 
-- MAGIC ### 3-1. 정규화란?
-- MAGIC - 목적: 중복된 데이터를 최대한 줄이기
-- MAGIC   - 보통 `최적화`라고 함(중복된 데이터는 관리도 어렵고, 불필요한 저장공간을 가지고 있으며, 연산결과도 느리게 만듬)
-- MAGIC - 따라서 중복된 데이터를 줄이려면 공통사항을 한 곳으로 모아놓고 필요에 따라서 연결시켜, 하나의 완전한 객체를 생성 = 정규화

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 3-2. Join문이란?
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

-- DBTITLE 1,실습용 테이블 1
select * from employee

-- COMMAND ----------

-- DBTITLE 1,실습용 테이블 2
select * from department

-- COMMAND ----------

-- select 보고싶은 모든 컬럼
-- from A테이블 a
-- inner join B테이블 b 
-- on a.기준 컬럼 = b.기준 컬럼;

-- COMMAND ----------

-- DBTITLE 1,조건문(deptno가 같은 것)에 기반하여 두 테이블 모두에 충족하는 값(deptno 20,30,40)만 출력
use megazone;

SELECT id, name, employee.deptno, deptname
FROM employee
INNER JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,Inner Join이 default값이기 때문에 join만 입력해도 무방
SELECT id, name, employee.deptno, deptname
FROM employee
JOIN department ON employee.deptno = department.deptno;

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

-- DBTITLE 1,예제: A, B 테이블 중에서 A값의 전체와 A의 key와 B의 key가 같은 결과 리턴
-- select 보고싶은 모든 컬럼
-- from A테이블 a
-- left join B테이블 b 
-- on a.기준 컬럼 = b.기준 컬럼;


-- 핵심은
-- A테이블  LEFT JOIN  B테이블

-- 왼쪽이 기준이므로 (left이니까), A테이블이 기준

-- COMMAND ----------

-- DBTITLE 1,Employee 기준으로 Left Join 수행(6개의 행을 가진 employee를 기준으로 이에 매치되는 department까지 출력. 없는 값은 null.)
SELECT id, name, employee.deptno, deptname
FROM employee
left JOIN department
ON employee.deptno = department.deptno;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 3. Right (Outer) Join
-- MAGIC - 우측을 기준으로 합니다.
-- MAGIC - 예를 들어, `...FROM A LEFT JOIN B...`인 경우, 오른쪽에 있는 B의 모든 값을 다 보여주면서(B데이터 범위 안에 한정) 이에 매치되는 A까지 함께 보여줌.

-- COMMAND ----------

-- DBTITLE 1,department 기준으로 Right Join 수행(4개의 행을 가진 department 를 기준으로 이에 매치되는 employee까지 출력. 없는 값은 null.)
SELECT id, name, employee.deptno, deptname
FROM department
RIGHT JOIN employee 
ON employee.deptno = department.deptno;

-- COMMAND ----------

-- DBTITLE 1,앞에서 진행한 left join과 결과 비교(메인 테이블을 어디로 잡느냐의 차이)
SELECT id, name, employee.deptno, deptname
FROM employee
left JOIN department
ON employee.deptno = department.deptno;

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

-- DBTITLE 1,출력 deptno에 따라 값이 바뀜. (오른쪽 테이블의 deptno를 출력하라고 했으므로, join에 실패한 라인은 null로 표시됨)
SELECT id, name, department.deptno, deptname
FROM employee
FULL JOIN department ON employee.deptno = department.deptno;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 5. self Join
-- MAGIC - 동일 테이블 사이의 조인
-- MAGIC - 따라서 From절에 동일한 테이블이 2번 이상 작성됨.
-- MAGIC - 동일 테이블 join을 할때는 테이블과 컬럼 이름이 모두 동일하기 때문에 식별을 위해 반드시 alias(as)를 사용해야함.

-- COMMAND ----------

select * from emp_s;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC - 유과장의 직속 상관은 홍대표
-- MAGIC - 하대리와 노대리의 직속 상관은 유과장
-- MAGIC 
-- MAGIC - 각 사원들의 직속상관을 같은 행에 출력하고 싶을 때, 셀프 조인 이용

-- COMMAND ----------

-- DBTITLE 0,Untitled
select a.emp_id, a.name as `직원명`, b.name as `직속상관`
from emp_s as a
inner join emp_s as b
on a.direct_supervisor_id = b.emp_id;

-- COMMAND ----------

-- left join을 이용하여 직속 상관이 없는 홍대표까지 출력해보기
select a.emp_id, a.name as `직원명`, b.name as `직속상관`
from emp_s as a
left join emp_s as b
on a.direct_supervisor_id = b.emp_id;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 6. cross Join
-- MAGIC - 상호 모든 행에 대한 결합 (on을 사용하지 않는다)
-- MAGIC - employee는 6행, department는 4행
-- MAGIC - 둘의 조합은 6*4 = 24행
-- MAGIC - cross join 시 출력되어야할 행은 24

-- COMMAND ----------

select * from employee

-- COMMAND ----------

select * from department;

-- COMMAND ----------

select *
from employee
cross join department;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 5. Window 함수
-- MAGIC - window 함수 개요
-- MAGIC - 행과 행간의 관계를 쉽게 정의하는게 목적. (주로 순위, 합계, 평균 등을 조회할 때 사용!!)
-- MAGIC   - Ranking 함수
-- MAGIC   - Analytic 함수
-- MAGIC   - Aggregate 함수

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##### 순위매기는 3가지 방법
-- MAGIC - rank()
-- MAGIC - dense_rank()
-- MAGIC - row_number()

-- COMMAND ----------

-- DBTITLE 1,5-1-1. Ranking 함수(rank())
-- 그룹 내 순위 함수
-- SELECT rank() OVER (PARTITION BY window_partition ORDER BY window_ordering) from table

-- 특정 범위는 partition by로 한정시킬 수 있음.  (전체 집합을 기준에 의해 소그룹으로 나눌 수 있음 like group by)
-- order by로 순위 매길 대상 선정 (어떤 항목을 순위 매길 것인가 지정)
-- 여러개이면 상위가 기준

select ename, deptno, sal,
rank() over (order by sal desc) as `전체 순위`,
rank() over (partition by deptno order by sal desc) as `부서내 순위`
from emp;

-- COMMAND ----------

-- 이건 dept 기준 정렬(dept 내 salary로 정렬)


select ename, deptno as dept, sal as salary,
  rank() over (order by sal) as `전체 순위`,
  rank() over (partition by deptno order by sal) as `부서내 순위`
from emp;

-- COMMAND ----------

-- DBTITLE 1,5-1-2. Ranking 함수(dense_rank())
-- 순위매기는 다른 방법
-- rank는 1,2,2,2,5로 등수를 매기지만
-- dense_rank는 1,2,2,2,3으로 순위를 매긴다.

select ename,
rank() over (order by sal) as ranks,
dense_rank() over (order by sal) as dens_ranks
from emp;

-- COMMAND ----------

-- DBTITLE 1,5-1-3. Ranking 함수(row_number())
-- 순위매기는 다른 방법
-- rank는 1,2,2,2,5로 등수를 매기지만
-- dense_rank는 1,2,2,2,3으로 순위를 매기지만
-- row_number은 1,2,3,4,5등으로 순위를 매긴다. (동일한 salary의 경우, 정렬 순서에 따라 순위 바뀜)
-- 이 순위 기준은 없음.

select ename,
rank() over (order by sal) as `ranks_1번방법`,
dense_rank() over (order by sal) as `dens_ranks_2번방법`,
row_number() over (order by sal) as `row_number_ranks_3번방법`
from emp
order by `ranks_1번방법`, ename
;

-- COMMAND ----------

`row_number_ranks_3번방법`select *,
rank() over (partition by deptno order by sal) as `ranks_1번방법`,
dense_rank() over (partition by deptno order by sal) as `dens_ranks_2번방법`,
row_number() over (partition by deptno order by sal) as `row_number_ranks_3번방법`
from emp
order by deptno, sal, ename;

-- COMMAND ----------

-- DBTITLE 1,5-2-1. Analytic 함수(lead()) 
-- MAGIC %md
-- MAGIC - lead: 후행 로우값(현재 행 뒤에 있는 행의 값을 반환(가져옴))
-- MAGIC - lag: 선행 로우값(현재 행 앞에 있는 행의 값을 반환(가져옴))

-- COMMAND ----------

-- 부서별(partition by) age순으로 정렬(order by)으로 출력된 후행 salary값 출력.
-- (현재 행 다음 행을 출력)

select *,
lead(salary) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- 1행후 값 가져오기
select *,
lead(salary, 1) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- 2행후 값 가져오기

select *,
lead(salary, 2) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- 2행후 값 가져오기 + null을 99999로 채우기
select *,
lead(salary, 2, 99999) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- DBTITLE 1,5-2-1. Analytic 함수(LAG()) - lead와 동일하게 작동하지만 후행이 아닌 선행
-- 1행전 값 가져오기
select *,
lag(salary) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- 2행전 값 가져오기
select *,
lag(salary, 2) over (partition by dept order by age) as lead_salary
from emp_w;

-- COMMAND ----------

-- 2행전 값 가져오기 + null을 99999로 채우기
select *,
lag(salary, 2, 0) over (partition by dept order by age) as lead_salary
from emp_w;

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

select *
from (
  select 
    ename,
    job,
    sal,
    avg(sal) over (partition by job) as job_avg_sal
  from emp
)
where sal > job_avg_sal

-- COMMAND ----------

-- 윈도우 함수의 경우 10행이 그대로 살아있음.
-- https://kimsyoung.tistory.com/entry/SQL-%EB%82%B4-%EC%A7%91%EA%B3%84-%ED%95%A8%EC%88%98-vs-%EC%9C%88%EB%8F%84%EC%9A%B0-%ED%95%A8%EC%88%98-%EC%9C%A0%EC%82%AC%EC%A0%90%EA%B3%BC-%EC%B0%A8%EC%9D%B4%EC%A0%90

select id, dates, city, amount,
-- 변형(아래 group by값을 partition by에 추가)
avg(amount) over(partition by dates, city order by amount) as avg_amount_daily
from transactions
-- group by dates, city
;

-- COMMAND ----------


