-- 1
create table new_emp(
	no number(5)
	, name varchar(20)
	, hiredate date
	, bonus number(6,2)
);

-- 2
create table new_emp2(
	no number(5)
	, name varchar(20)
	, hiredate date
);

-- 3
create table new_emp3 as 
select * from new_emp2 where 1=2;

-- 4
alter table new_emp2 drop column create_birthday;
alter table new_emp2 add(birthday date default sysdate);

-- 5
alter table new_emp2 rename column birthday to birth;

-- 6
alter table new_emp2 modify(no number(7));

select * from all_tab_columns
where table_name = 'NEW_EMP2';

-- 7
alter table new_emp2 drop column birth;
select * from new_emp2;

-- 8
truncate table new_emp2;
select * from new_emp2;

-- 9
drop table new_emp2;
select * from new_emp2;

-- 10
/* 데이터 딕셔너리는 user_xxx, all_xxx, dba_xxx 세가지가 있다.
   user_xxx는 자신의 계정이 소유한 객체에 대한 정보를 조회할 수 있고
	 all_xxx는 자신계정소유와 권한을 부여 받은 객체등에 대한 정보를 조회할 수 있고
	 dba_xxx만 데이터베이스관리자만 접근이 가능한 객체들의 정보를 조회할 수 있는 권한이 있다.
*/























