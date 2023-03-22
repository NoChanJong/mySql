/* 그룹함수 */
-- 1. count : 조건에 맞는 행의 갯수를 리턴
select count(*) from emp;
select count(ename) from emp;
select count(comm) from emp;
select count(nvl(comm, 0)) from emp;
select count(ename) from emp where deptno = 10;
select count(sal), count(comm), count(nvl(comm, 0)) from emp;
select count(sal), count(comm), count(nvl(comm, 0)) from emp where comm is not null;

-- 2. sum()
select sum(sal) from emp;
select sum(comm) from emp;
select sum(ename) from emp; -- (x) 문자열이기 때문에 에러
select count(ename) 총사원수
, sum(sal) 총급여
, round(sum(sal)/count(ename), 0) 평균급여 
from emp;

-- 3. avg()
select count(ename) 총사원수, sum(sal) 총급여, round(sum(sal)/count(ename), 0) 평균급여 from emp
union all
select count(ename) 총사원수, sum(sal) 총급여, round(avg(sal), 0) 평균급여 from emp;

-- 4. min/max
select min(sal + nvl(comm, 0)) 최저급여,
			 max(sal + nvl(comm, 0)) 최대급여
from emp;

-- 최초입사일, 최후입사일
select min(hiredate) 최초입사일,
			 max(hiredate) 최후입사일
from emp;

-- 이름
select min(ename) 알파벳빠른사원이름,
			 max(ename) 알파벳늦은사원이름
from emp;

-- 최초입사자는? 최후입사자?
-- 최저급여자? 최대급여자?
-- 사워이름출력
select ename from emp 
where HIREDATE = (select min(HIREDATE) from emp);

select ename from emp 
where HIREDATE = (select max(HIREDATE) from emp);

select min('최저급여자는 ' || ename || sal) 최저급여자,
			 max('최대급여자는 ' ||ename || ) 최대급여자
from emp;

/* 그룹화하기

	select group by 절에 지정된 컬럼1 group by별로 집계할 값
	from table_name
	group by 그룹으로 묶을 컬럽 값 
	
	1. select절에 그룹함수 이외의 컬럼이나 표현식을 사용할 경우에는 반드시
		 group by절에 선언이 되어야 한다.
  2. group by절에 선언된 컬럼은 select절에 선언되지 않아도 된다.
	3. group by절에는 반드시 컬럼명이나 표현식이 사용되어야 한다.
		 즉, 컬럼의 별칭은 사용할 수 없다.
  4. group by절에 사용한 열기준으로 정렬하기 위해서는 order by절을 사용하는
		 경우에는 반드시 group by절 뒤에 선언되어야 한다.
  5. order by절에는 컬럼의 순서, 별칭으로도 선언할 수 있다.
*/
select 10, sum(sal) from emp where deptno = 10
union all
select 20, sum(sal) from emp where deptno = 20
union all
select 30, sum(sal) from emp where deptno = 30;

select 10, sum(sal) 
from emp 
where deptno = 10
group by deptno;

select sum(sal) 
from emp 
where deptno = 10
group by deptno;

select deptno 부서명, sum(sal) 
from emp 
where deptno = 10
group by deptno;

select deptno 부서번호, sum(sal) 
from emp 
group by deptno;

select deptno 부서번호, sum(sal) 
from emp 
order by deptno
group by deptno;

-- order by : 검색된 결과의 행을 정렬할 때 쓰이는 함수이다.
-- 						정렬 방법에는 오름차순(asc)과 내림차순(desc)
-- 						컬럼으로 정리 -> order by col_name, col_name....asc(desc)
-- 						별칭으로 정리 -> order by 별칭1, 별칭2,.... asc(desc)
-- 						
select deptno 부서번호, sum(sal) 
from emp 
group by deptno
order by deptno;

select deptno 부서번호, sum(sal) 
from emp 
group by deptno
order by 1;

select deptno 부서번호, sum(sal) 
from emp 
group by deptno
order by 부서번호;

select deptno 부서번호, sum(sal) 
from emp 
group by deptno
order by sum(sal) desc;

-- 실습. emp
-- 1. 부서별로 사원수와 급여평균, 급여합계를 구하기, 정렬은 부서(deptno)
select deptno, count(*), round(avg(sal), 0), sum(sal)
from emp
group by deptno
order by deptno;

-- 2. 직급별로 인원수, 평균급여, 최고급여, 최소급여, 급여합계, 정렬은 직급(job)
select job, count(*), round(avg(sal), 0), max(sal), min(sal), sum(sal)
from emp
group by job
order by job;

/*
	having 조건절 - 그룹결과를 조건별로 조회하기
	
	select group by 절에 지정된 컬럼1 group by별로 집계할 값
	from table_name
	group by 그룹으로 묶을 컬럽 값 
	having 조건 추가;
	
	단일행에서의 조건은 where을 사용하지만 그룹함수에서의 조건절은
	having절을 사용한다.
	
	having절에는 집계함수를 가지고 조건을 비교할 경우에 사용되며
	having절과 group by절은 함께 사용할 수 있다. having절은 group by절 없이 사용할 수 없다.
*/
-- 직급별 평균급여, 직급별 평균급여 3000보다 큰 직급만 조회
select job 직급별
, count(deptno)
, sum(sal) 직급별합계
, round(avg(sal), 0) 직급별평균급여
, max(sal) 최대급여
, min(sal) 최소급여
from emp
group by job
having round(avg(sal), 0) >= 3000;

-- 실습
-- 1. 부서별 직업별 평균급여, 사원수
-- 2. 부서별			  평균급여, 사원수
-- 3. 총계					평균급여, 사원수
select 부서, 직급, 평균, 사원수
from (select deptno 부서, job 직급, round(avg(sal), 0) 평균, count(*) 사원수 from emp group by deptno, job
      union all
			select deptno 부서, null, round(avg(sal), 0), count(*) from emp group by deptno
			union all
			select null, null, round(avg(sal), 0), count(*) from emp) t1
order by 부서, 직급;

-- rollup : 자동으로 소계와 합계를 구해주는 함수
-- 					group by절과 같이 사용되며, 그룹 지어진 집합 결과에 대해서 좀 더 
-- 					상세한 정보를 반환하는 기능을 한다
-- group by : rollup(deptno, job) -> n + 1의 그룹 생성
-- 순서에 주의

select deptno
, nvl(job, '부서합계')
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 0) 급여평균
from emp
group by rollup(deptno, job);

select deptno
-- , nvl(job, '부서합계')
,job
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 0) 급여평균
from emp
group by deptno, rollup(job);

select deptno
, job
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 0) 급여평균
from emp
group by rollup(job, deptno);

-- 실습.
-- PROFESSOR테이블에서 deptno, position별로 교수인원수, 급여합계구하기
-- rollup함수 사용
select * from PROFESSOR;

select deptno, position
, count(*) 교수인원수
, sum(pay)
from PROFESSOR
group by rollup(deptno, position);

-- cube : rollup 함수와 다르게 합계를 먼저 표시한다
select deptno, position
, count(*) 교수인원수
, sum(pay)
from PROFESSOR
group by cube(deptno, position);

-- grouping : 소계, 합계로 집계된 행의 컬럼 null을 구분할 수 있다.
-- 						null인 경우 1을 반환하고 아닌경우 0을 반환한다.

-- grouping-id : 여러 칼럼을 매개변수로 사용할 수 있다.
-- 							 매개변수의 컬럼 순서에 맞게 해당 컬럼이 null인 경우 1을 반환하고
-- 							 한 행을 2진수라고 생간하면 된다.


























