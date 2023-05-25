/*
	Function
	
	1. function
	
		 보통의 경우 값을 계산하고 그 결과를 반환하기 위해서 function을 사용한다. 
		 대부분 procedure과 유사하지만
		 
		 1) in 파라미터만 사용할 수 있다.
		 2) 반드시 반환될 값의 데이터 타입을 return문안에 선언해야한다.	
	
	2. 문법
	
		 1) pl/sql 블럭안에는 적어도 한개의 return문이 있어야 한다.
		 2) 선언방법
		 
				create or replace function 펑션이름(arg1 in 데이터타입, ....)
				return 데이터타입 is[as]
					변수선언...
				[pragma autonomous_transaction]
				begin
				end 펑션이름;
	
	
	3. 주의사항
	
		 오라클함수 즉, function에서는 기본적으로 DML(insert, update, delete)문을 사용할 수 없다.
		 만약 사용하고자 할 경우 begin 바로 위에 pragma autonomous_transaction을 선언하면 사용할 수 있다.
			 
			 
  4. procedure vs function
	
		 procedure															function
		 --------------------------------     	-----------------------------
		 서버에서 실행(속도가 빠름)							클라이언트에서 실행
		 return값이 있어도되고 없어도 됨				return값이 필수
		 return값이 여러개(out 여러개)					return값이 하나만 가능
		 파라미터는 in, out											in만 있다		 
		 select절에 사용불가										select절에서 사용 가능
			--> call, execute												--> select 펑션() from dual;		 
		 
*/
-- 실습1. 사원번호를 입력받아서 급여를 10% 인상하는 함수작성하기
create or replace function fn_01(p_empno in number) return number is
	v_sal					number;
pragma autonomous_transaction;
begin
	update emp
	set sal = sal * 1.1
	where empno = p_empno;
	
	commit;
	
	select sal
	into v_sal
	from emp
	where empno = p_empno;
	
	return v_sal;
end fn_01;

select sum(sal) from emp;
select fn_01(7369) from dual;

-- call fn_01(7369); procedure는 call로 호출이 가능하지만 function할 수 없다.

-- 실습2. 부피를 계산하는 함수 fn_02
-- 부피 = 길이 * 넓이 * 높이 
create or replace function fn_02(p_num1 in number, p_num2 in number, p_num3 in number) return number is
	v_result				number;
begin
	
	v_result := p_num1 * p_num2 * p_num3;
	
	return v_result;
end fn_02;

select fn_02(10, 10, 10) from dual;

-- sql*plus : execute fn_02(10, 10, 10);

-- 실습3. 현재일을 입력받아서 해당월의 마지막일자를 구하는 함수
create or replace function fn_03(p_date in date) return date is 
	v_lastday				date;
begin

	v_lastday := add_months(p_date, 1) - to_char(p_date, 'DD');
	
	return v_lastday;

end fn_03;

select fn_03(sysdate) from dual;

-- 실습4. '홍길동'문자열을 전달받아서 '길동'만 리턴하는 함수 fn_04

create or replace function fn_04(p_name in varchar2) return varchar2 is 
	v_name 			varchar2(10);
begin

v_name := substr(p_name, 2);

return v_name;

end fn_04;

select fn_04('홍길동') from dual;
select fn_04(ename) from emp;

-- 실습5. fn_05: 현재일 입력받아서 '2023년 04월 03일'의 형태로 리턴
create or replace function fn_05(p_date in date) return varchar2 is 
	v_result 				varchar2(50);
begin

	v_result := to_char(p_date, 'YYYY"년" MM"월" DD"일"'); 
	-- to_char 문자열 변환 함수로 변수(v_result)와 return값의 데이터 타입을 문자열로 해줌
	
	return v_result;
end fn_05;

select fn_05(sysdate) from dual;
select fn_05(hiredate) from professor;

-- 실습6. fn_06: jumin번호를 입력받아서 남자 or 여자인지를 리턴
select jumin from STUDENT;

create or replace function fn_06(p_jumin in varchar2) return varchar2 is 
	v_result        varchar2(20);
begin

	v_result := substr(p_jumin, 7, 1);
	
	if v_result in('1', '3') 
	then v_result := '남자';
	else v_result := '여자';
	end if;		
	
return v_result;
end fn_06;

select name, fn_06(jumin) gender from STUDENT;

-- 실습7. fn_07: professor에 hiredate를 현재일기준으로 근속년월을 계산함수
-- 근속년 floor(months_between()), 근속월 ceil(months_between()) -> 12년 5개월
select to_char(hiredate, 'mm') from PROFESSOR;

create or replace function fn_07(p_date in date) return varchar2 is
	v_result 				varchar2(50);
begin
v_result := 
floor(months_between(sysdate, p_date)/12) || '년 ' || 
ceil(mod(months_between(sysdate, p_date), 12)) || '개월';

return v_result;

end fn_07;

select fn_07(hiredate) from professor;
















































