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
select * from emp;
select deptno
, nvl(job, '부서합계') 직업
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 0) 급여평균
from emp;
group by rollup(deptno, job);

select deptno
, nvl(job, '부서합계')
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
-- 1. 부서별 직급별 사원수 평균급여
-- 2. 부서별				사원수 평균급여
-- 3. 			 직급별 사원수 평균급여
-- 4. 전체					사원수 평균급여
select deptno, position
, count(*) 교수인원수
, sum(pay)
from PROFESSOR
group by cube(deptno, position)

select deptno
, job
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 2) 평균급여
from emp
group by rollup(deptno, job);

select deptno
, job
, count(*) 사원수
, round(avg(sal + nvl(comm, 0)), 2) 평균급여
from emp
group by cube(deptno, job);

/* 
	GROUPING 함수 : 그룹쿼리에서 사용하는 함수로 파라미터의 평가값이 null이면 1을 리턴하고
									null이 아닌 경우에는 0을 반환한다
				주의사항 -> grouping 함수에서 파라미터로 들어오는 값은 반드시 
										group by절에서 명시되어야 한다.

	GROUPING_ID 함수 : GROUPING함수는 null 여부만 체크해서 0과 1을 리턴하지만,
										 GROUPING_ID 함수는 그룹핑 레벨을 리턴한다.
		 1) grouping_id 표현식의 값이 null인지 여부에 따라 null이 아니면 0, null이면 1을 리턴한다.
		 2) 비트벡터로 변환한다(2진수화됨) : grouping_id(컬럼 a, 컬럼 b) 
											a, b 둘다 조회되면 -> 00
											a가 조회되고, b가 null이면 -> 01
											a가 null이고, b만 조회되면 -> 10
											둘다 조회가 안된다면 -> 11
		 3) 10진수로 변환한후 리턴 : 00 -> 0, 01 -> 1, 10 -> 2, 11 -> 3
		 4) grouping_id 함수도 그룹함수 이므로 having절에 조건을 명시할 수 있다.
		 
		주의사항 : 컬럼의 순서를 바꿔주면 비트벡터가 변해 결과값이 바뀌므로 
						   그룹레벨을 정확히 조회하려면 순서를 맞게 배치해야 한다.
	
	GROUPING SETS : group by의 확장된 형태로 하나의 group by절에 여러개의 
									그룹 조건을 기술할 수 있다.
	   1) grouping sets 함수의 결과는 각 그룹 조건에 대해 별도로 group by한 결과를
				union all한 결과와 동일하다.
		 2) union all등을 사용하여 복잡하게 sql문장을 작성했던 것을 간단하게 한 문장
				으로 해결할 수 있다.
				
		 예) grouping sets 예제
		 
				 select deptno, jobm sum(sal)
				 from emp
				 group by grouping sets(deptno, job);
				 
				 union all을 사용한 예제
				 
				 select null deptno, job, sum(sal)
				 from emp
				 group by job
				 union all
				 select deptno, null job, sum(sal)
				 from emp
				 group by deptno;										 
*/


<<<<<<< HEAD













>>>>>>> 1a0983907dd059c07a196fad610134ef001f5dc9
/*
	E. 순위함수
	
	1. rank()			  : 순위부여함수, 동일처리 1,2,2,4
	2. dense_rank() : 순위부여함수, 동일처리 1,2,2,3
	3. row_number() : 행번호를 제공해 주는 함수 동일처리는 불가 1,2,3,4
	
	[주의할 점]
	순위함수는 반드시 order by절과 같이 사용해야 한다.
*/
-- 1. rank()
-- 1) 특정자료별로 순위 : rank(조건값) within group(order by 조건값, 컬럼[asc|desc])
-- 2) 전체자료기준 순위 : rank(조건) over(order by 조건값, 컬럼[asc|desc])

-- 실습.
-- 1) 특정조건의 순위
-- SMITH사원이 알파벳순으로 몇번쨰인지
select rownum, ename from emp;
select rownum, emp.ename from emp;
select rownum, e.ename from emp e;
select rownum, ename from emp order by ename;
select rownum, t1.rn, t1.ename from (select rownum rn, ename from emp order by ename) t1;

select rank('SMITH') within group(order by ename) from emp;
select rank('SMITH') within group(order by ename asc) from emp;
select rank('SMITH') within group(order by ename desc) as 사원명 from emp;

-- 2) 전체자료에서의 순위
-- emp에서 각 사원들의 급여순위는?
-- 급여가 작은순(asc), 급여가 많은순(desc)
select * from emp order by sal;

select ename, sal
, rank() over(order by sal) -- 급여 적은순
, rank() over(order by sal desc) -- 급여 많은순
from emp;

-- 2. dense_rank()
select ename, sal
, rank() over(order by sal) -- rank()
, dense_rank() over(order by sal) -- dense_rank()
from emp;

-- 3. row_number() : 행번호
select ename, sal
, rank() over(order by sal) rank -- rank()
, dense_rank() over(order by sal) dense_rank -- dense_rank()
, row_number() over(order by sal) row_number -- row_number()
from emp;

/*
	F. 누적함수
	
	1. sum(컬럼) over([partition by 컬럼...]order by 컬럼 [asc|desc]) : 누계(누적)를 구하는 함수
	2. ratio_to_report() : 비율을 구하는 함수
*/

-- 1. sum() over()
select * from panmae;
select * from panmae where p_store=1000 order by 1;

-- 1000대리점의 판매일자별 누계액 구하기
select p_date
, p_code
, p_qty
, p_total
, sum(p_total) over(order by p_date) 일자별판매누계액 
from panmae  
where p_store=1000 order by 1;

-- 판매일자별 제품별 판매누계액
select * from panmae;

select p_date
, p_code
, p_qty
, p_total
, sum(p_total) over(order by p_date, p_code) 판매누계액 
from panmae  
where p_store=1000 order by 1;

-- 제품별/대리점별 기준으로 누계구하기(순서는 판매일자별)
select p_code
, p_store
, p_date
, p_total
, sum(p_total) over(partition by p_code, p_store order by p_date) 판매누계액 
from panmae;

-- 2. ratio_to_report()
-- 판매비율 
select p_code
, p_store
, sum(p_qty) over() 총판매수량
, round(ratio_to_report(sum(p_qty)) over() * 100, 2) "수량(%)"
, p_total
, sum(p_total) over() 총판매금액
, round(ratio_to_report(sum(p_total)) over() * 100, 2) "금액(%)"
from panmae
group by p_code, p_qty, p_store, p_total;

/* 연습문제 */
-- 1. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 
--    가장 적은 경우 , 평균 금액을 구하세요. 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 
--    출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요
-- MAX, MIN, AVG
select sal 급여
, nvl2(comm, comm, 0)보너스
, max(sal + nvl2(comm, comm, 0)) 가장많은경우
, min(sal + nvl2(comm, comm, 0)) 가장적은경우
, round(avg(sal + nvl2(comm, comm, 0))) 평균금액
from emp
group by sal, comm;

-- 2. student 테이블의 birthday 컬럼을 참조해서 월별로 생일자수를 출력하세요
-- TOTAL, JAN, ...,  5 DEC
--  20EA   3EA ....
select * from STUDENT;
select to_char(BIRTHDAY) from STUDENT;

select count(*) "생일자 합계"
, count(case when to_char(BIRTHDAY, 'MM') ='01' then '1월' end) "1월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='02' then '2월' end) "2월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='03' then '3월' end) "3월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='04' then '4월' end) "4월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='05' then '5월' end) "5월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='06' then '6월' end) "6월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='07' then '7월' end) "7월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='08' then '8월' end) "8월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='09' then '9월' end) "9월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='10' then '10월' end) "10월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='11' then '11월' end) "11월 생일자"
, count(case when to_char(BIRTHDAY, 'MM') ='12' then '12월' end) "12월 생일자"
from STUDENT;

select count(decode(to_char(BIRTHDAY, 'MM'), '01', 0)) || 'EA' as "1월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '02', 0)) || 'EA' as "2월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '03', 0)) || 'EA' as "3월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '04', 0)) || 'EA' as "4월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '05', 0)) || 'EA' as "5월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '06', 0)) || 'EA' as "6월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '07', 0)) || 'EA' as "7월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '08', 0)) || 'EA' as "8월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '09', 0)) || 'EA' as "9월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '10', 0)) || 'EA' as "10월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '11', 0)) || 'EA' as "11월"
			 , count(decode(to_char(BIRTHDAY, 'MM'), '12', 0)) || 'EA' as "12월"
from STUDENT;

-- 3. Student 테이블의 tel 컬럼을 참고하여 아래와 같이 지역별 인원수를 출력하세요.
--    단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM
--    으로 출력하세요
select count(*)  "합계"
<<<<<<< HEAD
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='02' then 'SEOUL' end ) || '명' as "서울"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='031' then 'GYEONGGI' end) || '명' as "경기"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='051' then 'BUSAN' end) || '명' as "부산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='052' then 'ULSAN' end) || '명' as "울산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='053' then 'DAEGU' end) || '명' as "대구"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='055' then 'GYEONGNAM' end) || '명' as "경남"
=======
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='02' then 'SEOUL' end) "서울"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='031' then 'GYEONGGI' end) "경기"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='051' then 'BUSAN' end) "부산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='052' then 'ULSAN' end) "울산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='053' then 'DAEGU' end) "대구"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='055' then 'GYEONGNAM' end) "경남"
>>>>>>> 1a0983907dd059c07a196fad610134ef001f5dc9
from STUDENT;


-- 4. emp 테이블을 사용하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력,
-- 단 급여를 오름차순으로 정렬해서 출력하세요.
-- sum() over()
select * from emp;

select ename
, sal 급여
, sum(sal) over(order by sal) 누적급여금액
<<<<<<< HEAD
from emp
order by 1;
=======
from emp;
>>>>>>> 1a0983907dd059c07a196fad610134ef001f5dc9

-- 6. student 테이블의 Tel 컬럼을 사용하여 아래와 같이 지역별 인원수와 전체대비 차지하는 비율을 
--    출력하세요.(단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU,055-GYEONGNAM)
select count(*) || '명(' || (count(*)/count(*)*100) || '%)' "합계"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='02' then 'SEOUL' end)/count(*)*100 || '%' as "서울"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='031' then 'GYEONGGI' end)/count(*)*100 || '%' as "경기"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='051' then 'BUSAN' end)/count(*)*100 || '%' as "부산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='052' then 'ULSAN' end)/count(*)*100 || '%' as "울산"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='053' then 'DAEGU' end)/count(*)*100 || '%' as "대구"
, count(case when substr(tel, 1, instr(tel, ')', 1, 1)-1)='055' then 'GYEONGNAM' end)/count(*)*100 || '%' as "경남"
from STUDENT;

-- 7. emp 테이블을 사용하여 부서별로 급여 누적 합계가 나오도록 출력하세요. 
-- ( 단 부서번호로 오름차순 출력하세요. )
select * from emp;

select job
, deptno
, sum(sal) over(partition by deptno order by sal)
from emp;

-- 8. emp 테이블을 사용하여 각 사원의 급여액이 전체 직원 급여총액에서 몇 %의 비율을 
--    차지하는지 출력하세요. 단 급여 비중이 높은 사람이 먼저 출력되도록 하세요
select deptno
, ename 
, sal 
, sum(sum(sal)) over() 전체직원급여합계
, round((ratio_to_report(sum(sal)) over()) * 100, 2)
from emp
group by deptno, ename, sal
order by sal desc;

-- 9. emp 테이블을 조회하여 각 직원들의 급여가 해당 부서 합계금액에서 몇 %의 비중을
--     차지하는지를 출력하세요. 단 부서번호를 기준으로 오름차순으로 출력하세요.
select * from emp;

select deptno
, ename
, sal
, sum(sum(sal)) over(partition by deptno order by sal) 부서합계
, round((ratio_to_report(sum(sal)) over(partition by deptno))*100, 2) 
from emp
group by deptno, ename, sal
order by 1;

































-- grouping : 소계, 합계로 집계된 행의 컬럼 null을 구분할 수 있다.
-- 						null인 경우 1을 반환하고 아닌경우 0을 반환한다.

-- grouping-id : 여러 칼럼을 매개변수로 사용할 수 있다.
-- 							 매개변수의 컬럼 순서에 맞게 해당 컬럼이 null인 경우 1을 반환하고
-- 							 한 행을 2진수라고 생간하면 된다.


























