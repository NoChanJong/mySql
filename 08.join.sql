/*
	Join 문법
	
	1. Oracle문법
	
		select t1.ename, t2.dname
			from emp t1, dept t2
			where t1.deptno = t2.deptno
	
	2. Ansi Join
	
		select t1.ename, t2.ename
			from emp t1 [inner|outer|full]join dept t2 on t1.deptno = t2.deptno
	
*/

select deptno, ename from emp;
select deptno, dname from dept;

-- orcle join
select ename, dname
from emp, dept
where emp.deptno = dept.deptno;


-- Ansi join
select ename, dname
from emp join dept on emp.deptno = dept.deptno;

select ename, dname
from emp inner join dept on emp.deptno = dept.deptno;

/*
	join의 종류

	1. equi-join(등가조인), A inner join B
		 특정 컬럼을 기준으로 정확히 매칭된 행들만 추출(A와 B의 교집합을 의미한다)
	2. outer join
	3. full join
*/

-- A. equi-join
-- 실습1. student, professor에서 지도교수의 이름과 학생이름을 출력
-- oracle문법, ansis문법 각각
-- 학생명과 교수명만 출력해 보기
select * from STUDENT;
select * from PROFESSOR;
select * from DEPARTMENT;

-- oracle
select std.name, pro.name
from STUDENT std, PROFESSOR pro
where std.deptno1 = pro.deptno;

select std.name 학생명, pro.name 교수명
from STUDENT std, PROFESSOR pro
where std.PROFNO = pro.PROFNO;

-- ansi
select std.name 학생명, pro.name 교수명
from STUDENT std inner join PROFESSOR pro 
on std.PROFNO = pro.PROFNO;

select count(*) from STUDENT;

select std.name 학생명, pro.name 교수명
from STUDENT std inner join PROFESSOR pro 
on std.PROFNO = pro.PROFNO;

-- 실습2. student, professor, department에서 교수명, 학생명, 학과명을 출력
-- oracle문법(where, and), ansi문법(inner 2번) 각각
-- where 조건에 and로 department묶기
select std.name 학생명, pro.name 교수명, dpt.dname 학과명
from STUDENT std, PROFESSOR pro, DEPARTMENT dpt
where std.PROFNO = pro.PROFNO
and pro.deptno = dpt.DEPTNO;

select std.name 학생명, pro.name 교수명, dpt.dname 학과명
from STUDENT std inner join PROFESSOR pro on std.PROFNO = pro.PROFNO
								 inner join DEPARTMENT dpt on pro.DEPTNO = dpt.DEPTNO;

-- B. outter-join
select count(*) from STUDENT;

select count(*) from STUDENT where profno is null;

-- 지도교수가 정해져 있지 않은 학생까지도 출력
-- 1) oracle에서만 사용되는 문법

-- 지도교수가 할당이 되지 않은 학생
select std.name 학생명, pro.name 교수명
from student std, professor pro
where std.profno = pro.profno(+);

-- 학생이 할당되지 않은 지도교수까지
select std.name 학생명, pro.name 교수명
from student std, professor pro
where std.profno(+) = pro.profno;

-- 2) ansi outter join
select std.name 학생명, pro.name 교수명
from student std inner join professor pro on std.profno = pro.profno;

-- 지도교수가 할당이 되지 않은 학생
select std.name 학생명, pro.name 교수명
from student std left outer join professor pro on std.profno = pro.profno;
-- left outer join
-- A left outer join B일 경우, A는 모두 다 추출하고
-- B는 A에 존재하는 행들만 추출한다(A가 기준이 됨)
-- A에 있는 B값만 가져온다. 
-- A에는 있는데 B에는 없는 경우 NULL처리

-- 학생이 할당되지 않은 지도교수
select std.name 학생명, pro.name 교수명
from student std right outer join professor pro on std.profno = pro.profno;
-- right outer join
-- A right outer join B를 하게 되면 B를 기준으로 A와 조인한다.
-- 기준이 되는 테이블은 right니까 오른쪽에 있는 B가 되는것

-- C. self join
select emp.empno, emp.ename -- 사원
		 , mgr.empno, mgr.ename -- 해당 사원의 매니저
from emp emp, emp mgr
where emp.mgr = mgr.empno;
-- emp테이블 두개를 가져와서 empno와 mgr컬럼이 같은 조건을 만족
-- (empno와 같은 mgr코드를 가진 사원의 해당 매니저 ename)
-- 하는 empno와 ename을 가져온다.

/* 연습문제 */
-- ex01) student, department에서 학생이름, 학과번호, 1전공학과명출력
select * from STUDENT;
select * from DEPARTMENT;

select std.name, dpt.deptno, dpt.dname 
from student std inner join department dpt on std.deptno1 = dpt.deptno;

select std.name 학생이름, dpt.deptno 학과번호, dpt.dname "1전공학과명"
from STUDENT std, department dpt
where std.deptno1 = dpt.deptno;

-- ex02) emp2, p_grade에서 현재 직급의 사원명, 직급, 현재 년봉, 해당직급의 하한
--       상한금액 출력 (천단위 ,로 구분)
select * from emp2;
select * from p_grade;

select emp2.name, emp2.position, emp2.pay, gra.s_pay, gra.e_pay
from emp2 emp2 inner join p_grade gra on emp2.position = gra.position;

select e.name, e.position 
		 , to_char(e.pay, '999,999,999')
		 , to_char(gra.s_pay, '999,999,999')
     , to_char(gra.e_pay, '999,999,999')
from emp2 e, p_grade gra
where e.position = gra.position;
-- ex03) emp2, p_grade에서 사원명, 나이, 직급, 예상직급(나이로 계산후 해당 나이의
--       직급), 나이는 오늘날자기준 trunc로 소수점이하 절삭 
select emp2.name
, trunc(months_between(sysdate, emp2.BIRTHDAY)/12)
, emp2.position
, gra.position
from emp2 emp2, p_grade gra
where trunc(months_between(sysdate, emp2.birthday)/12) between gra.S_AGE and gra.E_AGE; 

select emp.name
, trunc((sysdate - emp.birthday) / 365, 0) 나이
, emp.position 현재직급
, gra.position 예상직급
from emp2 emp, p_grade gra
where trunc((sysdate - emp.birthday) / 365, 0) between gra.s_age and gra.e_age;

-- ex04) customer, gift 고객포인트보나 낮은 포인트의 상품중에 Notebook을 선택할
--       수 있는 고객명, 포인트, 상품명을 출력    
select * from customer;
select * from gift;

select c.gname
, c.point
, g.gname
from customer c, gift g
where c.point >= g.G_START
and g.gname = 'Notebook';

-- ex05) professor에서 교수번호, 교수명, 입사일, 자신보다 빠른 사람의 인원수
--       단, 입사일이 빠른 사람수를 오름차순으로
select * from PROFESSOR;

select pro1.profno, pro1.name
			 , to_char(pro1.hiredate, 'YYYY/MM/DD') 
			 , count(nvl2(pro2.profno, pro1.profno, null)) 인원수
from PROFESSOR pro1, PROFESSOR pro2
where pro1.hiredate > pro2.hiredate(+)
group by pro1.profno, pro1.name, pro1.hiredate
order by 인원수 asc;

-- oracle
select pr1.profno 교수번호
, pr1.name 교수명
, to_char(pr1.hiredate, 'YYYY.MM.DD') 입사일자
, count(pr2.hiredate) 인원수
from PROFESSOR pr1, PROFESSOR pr2
where pr2.HIREDATE(+) < pr1.hiredate
group by pr1.profno, pr1.name, pr1.hiredate
order by 4;

-- ansi
select pr1.profno 교수번호
, pr1.name 교수명
, to_char(pr1.hiredate, 'YYYY.MM.DD') 입사일자
, count(pr2.hiredate) 인원수
from PROFESSOR pr1 left outer join  PROFESSOR pr2
on pr2.HIREDATE < pr1.hiredate
group by pr1.profno, pr1.name, pr1.hiredate
order by 4;
 
-- ex06) emp에서 사원번호, 사원명, 입사일 자신보다 먼저 입사한 인원수를 출력
--       단, 입사일이 빠른 사람수를 오름차순 정렬
select * from emp;

select e1.empno, e1.ename, to_char(e1.hiredate, 'YYYY/MM/DD')
, count(nvl2(e2.empno, e1.empno, null)) 인원수
from emp e1, emp e2
where e1.hiredate > e2.hiredate(+)
group by e1.empno, e1.ename, e1.hiredate
order by 인원수 asc; 

select e1.empno
, e1.ename
, to_char(e1.hiredate, 'YYYY.MM.DD')
, count(e2.hiredate)
from emp e1, emp e2
where e2.hiredate(+) < e1.hiredate
and e1.hiredate is not null
group by e1.empno, to_char(e1.hiredate, 'YYYY.MM.DD'), e1.ename
order by 4;


































-- table의 별칭
select e.ename, d.dname, e.deptno
from emp e, dept d
where e.deptno = d.deptno;





























