/*
	단일행함수(single function)
	
	A. 문자함수
	
	1. upper/lower : 대소문자변경함수 upper('abcde') -> ABCDE , lower('ABC') -> abc
	2. initcap : 첫 글자를 대문자로 변환, 나머지는 소문자 initcap('aBcDe') -> Abcde
	3. length : 문자열의 길이를 리턴 length('abcd') -> 4, length('한글') -> 2
	4. lengthb: 문자열의 byte단위 리턴(영문 = 1byte, 한글은 문자셋에 따라 2byte or 3byte 리턴)
							lengthb('한글') utf-8일 경우 6byte, euc-k 4byte
	5. concat : 문자열을 연결(||와 동일) concat('a', 'b') -> ab
	6. substr : 주어진 문자열에서 특정 위치의 문자를 추출 substr('aBcDe', 2, 2) -> Bc(두번째 부터 두자리 추출)
	7. substrb: 주어진 문자열에서 특정 위치의 byte만 추출 
		 substrb('한글', 1, 2) -> euc-kr일 경우 한
		 substrb('한글', 1, 2) -> utf-8일 경우 깨진문자
  8. instr : 주어진 문자열에서 특정문자의 위치를 리턴 instr('A*B#C#D', '#') -> 4
	9. instrb: 주어진 문자열에서 특정문자의 byte위치를 리턴 instr('한글로', '로') -> 7
 10. lpad  : 주어진 문자열에서 특정문자를 앞에서부터 채움 lpad('love', 6, '*') -> **love
 11. rpad  : 주어진 문자열에서 특정문자를 뒤에서부터 채움 rpad('love', 6, '*') -> love**
 12. ltrim : 주어진 문자열에서 앞의 특정문자를 삭제 ltrim('*love', '*') -> love
 13. rtrim : 주어진 문자열에서 뒤의 특정문자를 삭제 rtrim('love+', '+') -> love	
 14. replace:주어진 문자열에서 A를 B로 치환 replace('AB', 'A', 'C') -> CB
*/

-- 1. upper/lower
select ename from emp;
select lower(ename) from emp;
select upper(lower(ename)) from emp;

-- 2. initcap 
select initcap(ename) from emp;

-- 3. length() / lengthb()
select ename, length(ename) from emp;
select '소향' from dual; -- dual은 오라클에서 제공해주는 dummy 테이블
select * from dual;
select '소향', dummy from dual;

select '소향', length('소향'), lengthb('소향') from dual;

-- 4. concat() or ||
select name, id 
, concat(name, id)
, concat(name, '-') "name -"
, concat(concat(name, '-'), id) "name - id"
, concat(concat('홍길동의 직업', '의적입니다'), ' 주소는 조선한양') as 홍길동
, name || '-' || id as "name - id"
, '홍길동의 직업은 ' || '의적입니다.' || ' 주소는 한양입니다.' as "홍길동(2)"
from PROFESSOR;

-- 5. substr(값, from, length) / substrb(값, from, length)
-- from이 음수값이면 뒤에서 부터 처리
select 'abcdef' 
, substr('abcdef', 3) -- cdef
, substr('abcdef', 3, 2) -- cd
, substr('abcdef', -3) -- def
, substr('abcdef', -3, 2) -- de
from dual;

select '홍길동'
, substr('홍길동', 1, 1) 홍
, substrb('홍길동', 1, 1) X
, substrb('홍길동', 1, 3) 홍
from dual;

-- 실습. ssn 99118-1234567에서 성별구분만 추출해 보기
select '991118-1234567' 
, substr('991118-1234567', 8, 1) as 성별
-- 1/3이면 남자, 2/4이면 여자
from dual;

-- 6. instr(문자열, 검색글자, from(기본값 1), 몇 번째(기본값 1)
-- 검색글자의 위치를 리턴해 준다.
-- 시작위치가 음수이면 뒤에서부터 검색
select 'A*B*C*D'
, instr('A*B*C*D', '*') "2nd"
, instr('A*B*C*D', '*', 3) "4th"
, instr('A*B*C*D', '*', 1, 2) "4th" -- 처음부터 시작해서 2번째의 *의 위치
, instr('A*B*C*D', '*', -5, 1) "2nd"-- 뒤에서 5번쨰 위치에서부터 
, instr('A*B*C*D', '*', -1, 2) "4th"
from dual;

select 'HELLO WORLD'
, instr('HELLO WORLD', 'O') "5th"
, instr('HELLO WORLD', 'O', -1) "8th"
, instr('HELLO WORLD', 'O', -1, 1) "8th"
, instr('HELLO WORLD', 'O', -1, 2) "5th"
from dual;

-- 7. lpad(문자열, 자리수, 채울문자) / rpad(문자열, 자리수, 채울문자)
select name, id, length(id) 
, lpad(id, 10) -- 채울문자가 정의되지 않으면 공란으로 채워진다.
, lpad(id, 10, '*')
, lpad(id, 30, '*')
, rpad(id, 30, '*')
from student
where deptno1 = 101;

-- 8. ltrim/rtrim 
select ename
, ltrim(ename, 'C')
, rtrim(ename, 'R')
from emp
where deptno = 10;

select '   XXX   ' from dual union all
select ltrim('   XXX   ') from dual union all
select rtrim('   XXX   ') from dual;

-- 9. replace(문자열, 변경전문자, 변경후문자)
select ename
, replace(ename, 'KI', '**')
, replace(ename, 'I', '-----------')
-- **ARK, **NG, **LLER substr(), replace()
, substr(ename, 1, 2)
, replace(ename, substr(ename, 1, 2), '**')
from emp
where deptno = 10;

-- 연습문제
-- ex01) student 테이블의 주민등록번호 에서 성별만 추출
select jumin 
, substr(jumin, 7, 1)
from STUDENT;
-- ex02) student 테이블의 주민등록번호 에서 월일만 추출
select jumin, substr(jumin, 3, 4) as "출생 월일" from STUDENT;
-- ex03)70년대에 태어난 사람만 추출
select * from STUDENT;

select jumin from STUDENT 
where substr(jumin, 1, 2) < 80;

select jumin from STUDENT 
where substr(jumin, 1, 2) >= '70' 
and substr(jumin, 1, 2) < '80';

-- ex04) student 테이블에서 jumin컬럼을 사용, 1전공이 101번인 학생들의
--       이름과 태어난월일, 생일 하루 전 날짜를 출력
select jumin 
, name "이름"
, substr(jumin, 3, 2) || '월 ' || substr(jumin, 4, 2) || '일' "태어난월일" 
, substr(jumin, 3, 4) - 1 "생일 하루 전" -- substr(jumin, 3, 4) -> 문자가 숫자로 자동형변환
from STUDENT where DEPTNO1 = 101;
-- 형변환함수, 자동(묵시적)형변환, 수동(명시적)형변환

	
/*
	B. 숫자함수
	
	1. round : 주어진 실수를 반올림
	2. trunc : 주어진 실수를 버림
	3. mod	 : 나누기연산후 나머지값을 리턴
	4. ceil	 : 주어진 실수값에서 가장 큰 정수값을 리턴
	5. floor : 주어진 실수값에서 가장 작은 정수값을 리턴
	6. power : 주어진 값을 주어진 승수를 리턴 power(3, 3) -> 3^3 = 27
	7. rownum: 오라클에서만 사용되는 속성으로 모든 객체에 제공된다.
		 ....rownum은 전체열 즉, *와 같이 사용할 수 없다.
		 ....rownum은 행번호를 의미
*/
-- 1. round(실수, 반올림위치)
select 976.635
, round(976.635)
, round(976.635, 0)
, round(976.635, 1)
, round(976.635, 2)
, round(976.635, 3)
, round(976.635, -1)
, round(976.635, -2)
from dual;

-- 2. trunc(실수, 버림위치)
select 976.635
, trunc(976.235)
, trunc(976.235, 0)
, trunc(976.235, 1)
, trunc(976.235, 2)
, trunc(976.235, 3)
, trunc(976.235, -1)
, trunc(976.235, -2)
from dual;

-- 3. mod, ceil, floor
select 121
, mod(121, 10)
, ceil(121.1)
, floor(121.9)
from dual;

-- 4. power
select '2의 3승 = ', power(2,3) from dual union all
select '3의 3승 = ', power(3,3) from dual;

-- 5. rownum
select rownum, * from STUDENT; -- (x) rownum은 *와 같이 사용X
select rownum, name from STUDENT;
select rownum, name, id from STUDENT where deptno1 = 101;

/*
	C. 날짜함수
	
	1. sysdate : 시스템의 현재 날짜 -> 날짜형으로 리턴
	2. months_between : 두 날짜 사이의 개월수를 리턴 -> 숫자형으로 리턴
	3. add_months : 주어진 일자에 개월수를 더한 결과를 리턴 -> 날짜형으로 리턴
	4. next_day : 주어진 일자를 기준으로 다음 날짜를 리턴 -> 날짜형
	5. last_day : 주어진 일자에 해당하는 월의 마지막일자를 리턴 
	6. round : 주어진 날짜를 반올림
	7. trunc : 주어진 날짜를 버림
*/

-- 1. sysdate
select sysdate from dual;

-- 2. months_between
select months_between(sysdate, '20190101') from dual;

-- 근속월수는?
select months_between(sysdate, HIREDATE) from emp;

-- 3. add_months
select sysdate 
, add_months(sysdate, 2)
, add_months(sysdate, -2)
, add_months(sysdate, -12)
from dual;

-- 4. next_day
-- 현재일에서 다음의 요일
select sysdate 
, next_day(sysdate, 1) -- 1~7 : 일요일 ~ 토요일
, next_day(sysdate, 2)
, next_day(sysdate, 3)
, next_day(sysdate, 4)
, next_day(sysdate, 5)
, next_day(sysdate, 6)
, next_day(sysdate, 7)
from dual;

-- 5. last_day 
select sysdate
, last_day(sysdate)
, last_day('20240301')
, last_day('2024-03-01')
, last_day('2024.03.01')
, last_day('2024/03/01')
-- , last_day('2024-MAR-01') (x)
-- , last_day('03/01.2024') (x)
from dual;

-- 6. round/trunc
select sysdate
, round(sysdate)
, trunc(sysdate)
, round('20230402')
, trunc('20230429')
from dual;

select sysdate
, trunc(sysdate)
from dual;

/*
	D. 형변환함수
	
	1. to_char()	 : 날짜 or 숫자를 문자로 변환 
	2. to_number() : 문자형숫자를  숫자로 변환(단, 숫자형식에 맞아야 함)
	3. to_date()	 : 문자형을 날짜로 변환(단, 날짜형식에 맞아야 함)
*/

-- 1. 자동형변환 / 수동형변환
-- 1) 자동(묵시적)형변환
select '2' + 2 from dual -- '22'가 아니라 '2'가 숫자로 변환되고 연산
union all
select 2 +'2' from dual; -- 즉, 문자와 숫자의 연산의 우선순위는 숫자에 있다.

-- 2) 수동(명시적)형변환
select to_number('2') + 2 from dual
union all
select 2 + to_number('2') from dual;

select '2a' + 2 from dual; -- (x)
select 'A' + 2 from dual; -- (x)

-- 2. to_char()
-- 1) 날짜를 문자로 변환
select sysdate 
, to_char(sysdate)
, to_char(sysdate, 'YYYY') 년도
, to_char(sysdate, 'RRRR') 년도
, to_char(sysdate, 'YY') 년도
, to_char(sysdate, 'RR') 년도
, to_char(sysdate, 'yy') 년도
, to_char(sysdate, 'YEAR') 년도
, to_char(sysdate, 'year') 년도
from dual;

select sysdate 
, to_char(sysdate)
, to_char(sysdate, 'MM') 월
, to_char(sysdate, 'MON') 월
, to_char(sysdate, 'MONTH') 월
, to_char(sysdate, 'mm') 월
, to_char(sysdate, 'mon') 월
from dual;

select sysdate 
, to_char(sysdate)
, to_char(sysdate, 'DD') 일
, to_char(sysdate, 'DAY') 일
, to_char(sysdate, 'DDTH') 일
, to_char(sysdate, 'dd') 일
, to_char(sysdate, 'day') 일
, to_char(sysdate, 'ddth') 일
from dual;

select sysdate 
, to_char(sysdate)
, to_char(sysdate, 'YYYY.MM.DD')
, to_char(sysdate, 'yyyy.mm.dd')
, to_char(sysdate, 'yyyy.mm.dd hh:mi:ss')
, to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss')
, to_char(sysdate, 'mon.dd.yy hh:mi:ss')
from dual;

-- 2) 숫자를 문자로 변환
-- 12345 -> 12,345 or 12345.00 형태로 변환
select 12345 
, to_char(12345, '99999')
, to_char(12345, '9999999999l')
, to_char(12345, '0999999999')
, to_char(12345, '$99999')
, to_char(12345, '$99999.9')
, to_char(12345, '99,999')
from dual;

/* 연습문제 */
-- ex01) emp테이블에서 ename, hiredate, 근속년, 근속월, 근속일수 출력, deptno = 10;
-- months_between, round, turnc, 개월수계산(/12), 일수계산(/365, /12)
select DEPTNO from emp;

select ename 
, trunc(months_between(sysdate, HIREDATE)) 
, trunc(months_between(sysdate, hiredate)/12)
, trunc(months_between(sysdate, hiredate)/12 * 365) 
from emp
where deptno = 10;

-- ex02) student에서 birthday중 생일 1월의 학생의 이름과 생일을 출력(YYYY-MM-DD)
select * from STUDENT;

select name, 
to_char(BIRTHDAY, 'YYYY-MM-DD') 
from STUDENT
where substr(jumin, 3, 2) = 01;

-- ex03) emp에서 hiredate가 1,2,3월인 사람들의 사번, 이름, 입사일을 출력
select * from emp;

select empno, ename, hiredate
from emp
where substr(to_char(hiredate), 4, 2) = 01 
or substr(to_char(hiredate), 4, 2) = 02
or substr(to_char(hiredate), 4, 2) = 03;

-- ex04) emp 테이블을 조회하여 이름이 'ALLEN' 인 사원의 사번과 이름과 연봉을 
--       출력하세요. 단 연봉은 (sal * 12)+comm 로 계산하고 천 단위 구분기호로 표시하세요.
--       7499 ALLEN 1600 300 19,500   
select ename, sal from emp where ename = 'ALLEN';

select empno, 
ename, 
to_char((to_number(sal) * 12 + to_number(comm)), '99,999') "ALLEN 연봉"
from emp 
where ename = 'ALLEN';  

-- ex05) professor 테이블을 조회하여 201 번 학과에 근무하는 교수들의 이름과 
--       급여, 보너스, 연봉을 아래와 같이 출력하세요. 단 연봉은 (pay*12)+bonus
--       로 계산합니다.
--       name pay bonus 6,970
select * from PROFESSOR;

select name, pay, bonus, 
((pay*12) + nvl(bonus, 0))
from PROFESSOR
where deptno = 201;


-- ex06) emp 테이블을 조회하여 comm 값을 가지고 있는 사람들의 empno , ename , hiredate ,
--       총연봉,15% 인상 후 연봉을 아래 화면처럼 출력하세요. 단 총연봉은 (sal*12)+comm 으로 계산하고 
--       15% 인상한 값은 총연봉의 15% 인상 값입니다.
--      (HIREDATE 컬럼의 날짜 형식과 SAL 컬럼 , 15% UP 컬럼의 $ 표시와 , 기호 나오게 하세요)
select * from emp;

select empno, ename, to_char(hiredate, 'YYYY.MM.DD'), 
to_char(((sal*12)+comm), '$99,999'), 
to_char((((sal*12)+comm) + ((sal*12)+comm)*0.15), '$99,999')
from emp
where comm > 0; 




















