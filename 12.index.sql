/*
	인덱스란?
	
	인덱스는 특정 데이터가 HDD의 어느 위치(메모리)에 저장되어 있는지에 대한 정보를 가진 주소와 같은
	개념이다. 인덱스는 데이터와 위치주소(rowid)정보를 key와 value의 형태의 한쌍으로 저장되어 관리된다.
	인덱스의 가장 큰 목적은 데이터를 보다 빠르게 검색 or 조회할 수 있게 하기 위함이다.
	
	1. rowid구조
	
		rowid는 데이터의 위치정보 즉, HDD에 저장되어 있는 메모리주소로서 Oracle에서는 총 18bytes길이의 정보이다.
		rowid는 예를 들어 AAAw5jAAEAAAAFbAAA의 형태이다.
		1) 데이터오브젝트번호(6) : AAAw5j
		2) 파일번호					 (3) : AAE
		3) block번호				 (6) : AAAAFb
		4) row번호					 (3) : AAA
		
	2. index를 사용하는 이유 a
		
		1) 데이터를 보다 신속하게 검색할 수 있게 하도록 사용(검색속도를 향상)
		2) 보통 index테이블의 특정 컬럼에 한 개 이상을 주게되면 index table이 별도로 생성된다.
			 이 인덱스테이블에는 인덱스 컬럼의 row값과 rowid가 저장되고 row값은 정렬된 b_tree구조로
			 저장시켜서 검색시에 보다 빠르게 데이터를 검색할 수 있게 한다.
	  3) 하지만, update, delete, insert시에 속도가 느려지는 단점이 있다.
		
		
	3. index 필요한 이유
		
		1) 데이터가 대용량일 때
		2) where 조건절에 자주 사용되는 컬럼일 경우
		3) 조회결과 전체 데이터베이스의 3~5%미만일 경우 인덱스 검색이 효율적이고
			 보다 적은 비용으로 빠르게 검색할 수 있다.
			 
  4. index가 필요하지 않은 경우
	
		1) 데이터가 적을 경우(수천건 미만)에는 인덱스를 설정하지 않는 것이 오히려 성능에 좋다.
		2) 검색보다 update, delete, insert가 빈번하게 일어나는 테이블에는 인덱스가 없는 게 오히려 
			 좋을 수가 있다.
	  3) 조회결과 전체 행의 15%이상인 경우에는 사용하지 않는 것이 좋다.
		
	5. index가 자동생성되는 경우
	
		인덱스가 자동생성되는 경우는 테이블정의시에 PK, UK의 제약조건으로 정의할 때 자동으로 생성된다.
		
	6. 문법
	
		1) 생성방법 : create [unique] index 인덱스명 on 테이블명(컬럼1,....컬럼n)
		2) 삭제방법 : drop index 인덱스명;
			 -> index는 테이블에 종속되어 있기 때문에 테이블이 삭제가 될 때 자동으로 삭제가 된다.
	
	
	
	
*/
select rowid, ename from emp;

-- 1. rowid는 오라클 DB에서만 사용하는 개념으로 rowid를 검색할 수 있다.
-- 만약, rowid를 지원하지 않는 프로그램에서는 rowidtochar(rowid)함수를 이용해서 조회할 수 있다.
select rowid, ename from emp;
select rowidtochar(rowid), ename from emp;
select length(rowid) from emp;

select length(rowid)
, rowid -- 7521데이터가 저장되어 있는 HDD의 메모리 주소
, ename
, empno
from emp
where empno = 7521
union all
select length(rowid)
, rowid -- WARD가 저장되어 있는 HDD의 메모리 주소
, ename
, empno
from emp
where ename = 'WARD';

-- 2. index 조회 : data dictionary
select * from all_indexes;
select * from user_indexes;
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'EMP';

-- 3. index 생성(1) - unique index
create unique index idx_dept2_dname on dept2(dname);
create unique index xxx on dept2(area); -- cannot CREATE UNIQUE INDEX; duplicate keys found
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';

-- 4. index 생성(2) - not unique index
select * from dept2;
create index idx_dept2_area on dept2(area);
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';

-- 5. index 생성(3) - 결합인덱스
select ename, sal, job from emp where ename = 'SMITH' and job = 'CLERK';
select ename, sal, job from emp where job = 'CLERK' and ename = 'SMITH';
select count(*) from emp where job = 'CLERK';
select count(*) from emp where ename = 'SMITH';
select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

create index idx_emp_ename_job on emp(ename, job);
select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

-- 6. index rebuilding하기
-- 1) index 생성
drop table idx_test;
create table idx_test(no number);
select * from idx_test;

-- pl/sql
begin
for i in 1..100000 loop
	insert into idx_test values(i);
end loop;
commit;
end;

select count(*) from idx_test;

-- a. 인덱스 없이 조회하기
select * from idx_test order by no; -- 0.112s
select * from idx_test where no = 9000; -- 0.025s

-- b. 인덱스 생성후 조회하기
create unique index idx_test_no on idx_test(no);

select * from idx_test order by no; -- 0.103s
select * from idx_test where no = 9000; -- 0.016s

/* 연습문제 */

-- ex01) 테이블명 : STAR_WARS (영화 정보를 저장한다)
--       컬럼 : EPISODE_ID : 에피소드 아이디로써, 숫자형 타입으로 기본 키가 된다.
--              EPISODE_NAME : 에피소드에 따른 영화 제목, 가변길이문자형(50 BYTE)이다.
--              OPEN_YEAR : 개봉년도로써, 숫자형 타입이다.
create table star_wars (
	episode_id		number CONSTRAINT sw_episode_id_pk PRIMARY KEY
, episode_name	varchar2(50)
, open_year			number
);

drop table star_wars;
select * from star_wars;

-- ex02) 테이블명 : CHARACTERS ( 등장인물 정보를 저장한다)
--         컬럼 : CHARACTER_ID   : 등장인물 아이디로써, 숫자형 타입(5자리), 기본키
--                CHARACTER_NAME : 등장인물 명으로 가변 길이 문자형 타입(30 BYTE)이다.
--                MASTER_ID      : 등장인물이제다이일 경우 마스터아이디값, 숫자형(5자리)
--                ROLE_ID        : 등장인물의 역할 아이디로써, INTEGER 타입이다.
--                EMAIL          : 등장인물의 이메일 주소로 varchar2(40 BYTE)이다.
create table characters (
	character_id		number(5) CONSTRAINT char_character_id_pk PRIMARY KEY
, character_name  varchar2(30) 
, master_id				number(5)
, role_id					integer
, email						varchar2(40)
);

drop table characters;
select * from characters;

select * from user_constraints
where table_name = 'CHARACTERS';

-- ex03) 테이블명 : CASTING ( 등장인물과 실제 배우의 정보를 저장한다)
--         컬럼 : EPISODE_ID: 에피소드 아이디로써, 숫자형 타입(5자리)으로 기본키
--                CHARACTER_ID: 등장인물 아이디로써, 숫자형 타입(5자리)이며 참조키
--                REAL_NAME : 등장인물의 실제 이름으로, varchar2(30 BYTE)이다.
create table casting (
	episode_id		number(5) 
, character_id	number(5) 
, real_name			varchar2(30)
, constraint cast_episode_character_id_pk primary key(episode_id, character_id)
);

drop table casting;

-- ex04) INSERT 문을 사용하여 STAR_WARS 테이블에 다음과 같이 데이터를 저장해보자. 
-- EPISODE_ID  EPISODE_NAME                                 OPEN_YEAR              
-- ----------- ---------------------------------------  --------------                
-- 1              보이지 않는 위험(The Phantom Menace)          1999                   
-- 2              클론의 습격(Attack of the Clones)             2002                   
-- 3              시스의 복수(Revenge of the Sith)              2005
-- 4              새로운 희망(A New Hope)                       1977                   
-- 5              제국의 역습(The Empire Strikes Back)          1980                   
-- 6              제다이의 귀환(Return of the Jedi)             1983 
delete from star_wars;
insert into star_wars values(1, '보이지 않는 위험(The Phantom Menace)', 1999);
insert into star_wars values(2, '클론의 습격(Attack of the Clones)', 2002);
insert into star_wars values(3, '시스의 복수(Revenge of the Sith)', 2005);
insert into star_wars values(4, '새로운 희망(A New Hope)', 1977);
insert into star_wars values(5, '제국의 역습(The Empire Strikes Back)', 1980);
insert into star_wars values(6, '제다이의 귀환(Return of the Jedi)', 1983);
select * from star_wars;

-- ex05) CHARACTERS 테이블에 다음의 데이터를 저장해보자.
-- CHARACTER_ID    CHARACTER_NAME       EMAIL                                    
-- --------------- -------------------- ------------------------ 
-- 1                 루크 스카이워커          luke@jedai.com                           
-- 2                 한 솔로                  solo@alliance.com                        
-- 3                 레이아 공주              leia@alliance.com                        
-- 4                 오비완 케노비            Obi-Wan@jedai.com                        
-- 5                 다쓰 베이더              vader@sith.com                           
-- 6                 다쓰 베이더(목소리)       Chewbacca@alliance.com                   
-- 7                 C-3PO                   c3po@alliance.com                        
-- 8                 R2-D2                   r2d2@alliance.com                        
-- 9                 츄바카                   Chewbacca@alliance.com                   
-- 10                랜도 칼리시안
-- 11                요다(목소리)              yoda@jedai.com                           
-- 12                다스 시디어스
-- 13                아나킨 스카이워커        Anakin@jedai.com                         
-- 14                콰이곤 진
-- 15                아미달라 여왕
-- 16                아나킨 어머니
-- 17                자자빙크스(목소리)        jaja@jedai.com 
-- 18                다스 몰          
-- 19                장고 펫 
-- 20                마스터 윈두              windu@jedai.com                          
-- 21                듀크 백작                dooku@jedai.com
select * from characters order by character_id;

insert into characters(character_id, character_name, email) values(1, '루크 스카이워커', 'luke@jedai.com');
insert into characters(character_id, character_name, email) values(2, '한 솔로', 'solo@alliance.com');
insert into characters(character_id, character_name, email) values(3, '레이아 공주', 'leia@alliance.com');
insert into characters(character_id, character_name, email) values(4, '오비완 케노비', 'Obi-Wan@jedai.com');
insert into characters(character_id, character_name, email) values(5, '다쓰 베이더', 'vader@sith.com');
insert into characters(character_id, character_name, email) values(6, '다쓰 베이더(목소리)', 'Chewbacca@alliance.com');
insert into characters(character_id, character_name, email) values(7, 'C-3PO', 'c3po@alliance.com');
insert into characters(character_id, character_name, email) values(8, 'R2-D2', 'r2d2@alliance.com');
insert into characters(character_id, character_name, email) values(9, '츄바카', 'Chewbacca@alliance.com');
insert into characters(character_id, character_name, email) values(10, '랜도 칼리시안', null);
insert into characters(character_id, character_name, email) values(11, '요다(목소리)', 'yoda@jedai.com');
insert into characters(character_id, character_name, email) values(12, '다스 시디어스', null);
insert into characters(character_id, character_name, email) values(13, '아나킨 스카이워커', 'Anakin@jedai.com');
insert into characters(character_id, character_name, email) values(14, '콰이곤 진', null);
insert into characters(character_id, character_name, email) values(15, '아미달라 여왕', null);
insert into characters(character_id, character_name, email) values(16, '자자빙크스(목소리)', 'jaja@jedai.com');
insert into characters(character_id, character_name, email) values(17, '다스 몰', null);
insert into characters(character_id, character_name, email) values(18, '장고 펫', null);
insert into characters(character_id, character_name, email) values(19, '마스터 윈두', 'windu@jedai.com');
insert into characters(character_id, character_name, email) values(20, '듀크 백작', 'dooku@jedai.com');

-- ex06) ROLES 테이블에 다음의 데이터를 저장해보자
-- ROLE_ID(number5,0) pk, ROLE_NAME(varchar2 30)
-- 1001, '제다이'
-- 1002, '시스'
-- 1003, '반란군'
create table roles (
	role_id 	number(5,0) primary key
, role_name	varchar2(30)
);

insert into roles values(1001, '제다이');
insert into roles values(1002, '시스');
insert into roles values(1003, '반란군');

select * from roles;
-- ex07) CHARACTERS 에는 ROLE_ID 란 컬럼, 이 값은 ROLES 테이블의 ROLE_ID 값을 참조 
-- CHARACTERS 변경하여 ROLE_ID 컬럼이 ROLES의 ROLE_ID 값을 참조하도록 참조 키를 생성
select * from characters;
drop table roles;

alter table characters add constraint char_role_id_fk foreign key(role_id) references roles(role_id);

select * from user_constraints
where table_name = 'CHARACTERS';
-- ex08) 참조 키를 생성후, 다음으로 CHARACTERS 테이블의 ROLE_ID 값을 변경해보자. 
-- 값의 참조는 ROLES 테이블의 ROLE_ID 값을 참조한다. 예를 들면 루크 스카이워커,   
-- 오비완 캐노비, 요다 등은 제다이 기사이므로 1001 값을 가질 것이며, 
-- 다쓰 베이더, 다쓰 몰은 시스 족이므로 1002에 해당한다. 자신이 아는 범위 내에서 
-- 이 값을 갱신하는 UPDATE 문장을 작성해 보자.
select * from characters;
select * from roles;

update characters
set role_id = 1001
where email like '%jedai%';

update characters
set role_id = 1002
where email like '%sith%';

update characters
set role_id = 1003
where email like '%alliance%';

select * from characters;

-- ex09) CHARACTERS MASTER_ID 란 컬럼, 이 컬럼의 용도는 EMPLOYEES 테이블의 MANAGER_ID 
-- 와 그 역할이 같다. 즉 제다이나 시스에 속하는 인물 중 그 마스터의 CHARACTER_ID 값을 
-- 찾아 이 컬럼에 갱신하는 문장을 작성
-- 
-- 제자                    마스터
-- ------------------  -------------------------
-- 아나킨 스카이워커      오비완 캐노비
-- 루크 스카이워크        오비완 캐노비
-- 마스터 윈두            요다
-- 듀크 백작              요다
-- 다쓰 베이더            다쓰 시디어스
-- 다쓰 몰                다쓰 시디어스
-- 오비완 캐노비          콰이곤 진
-- 콰이곤 진              듀크 백작
select * from characters;

update characters
set master_id = (select character_id from characters where character_name = '오비완 케노비')
where character_name in ('아나킨 스카이워커', '루크 스카이워커');

update characters
set master_id = (select character_id from characters where character_name = '요다')
where character_name in ('마스터 윈두', '듀크 백작');

update characters
set master_id = (select character_id from characters where character_name = '다스 시디어스')
where character_name in ('다쓰 베이더', '다쓰 몰');

update characters
set master_id = (select character_id from characters where character_name = '콰이곤 진')
where character_name in ('오비완 케노비');

update characters
set master_id = (select character_id from characters where character_name = '듀크 백작')
where character_name in ('콰이곤 진');


-- ex010) CASTING의 PK는 EPISODE_ID와 CHARACTER_ID 이다. 
-- 이 두 컬럼은 각각 STAR_WARS와 CHARACTERS 테이블의 기본 키를 참조하고 있다. 
-- CASTING 테이블에 각각 이 두 테이블의 컬럼을 참조하도록 참조 키를 생성 
select * from casting;
select * from star_wars;
select * from characters;
drop table casting;

alter table casting add constraint cast_episode_id_fk foreign key(episode_id) references star_wars(episode_id);

alter table casting add constraint cast_character_id_fk foreign key(character_id) references characters(character_id);

select * from user_constraints
where table_name = 'STAR_WARS';
-- ex11) 다음 문장을 실행해 보자. 
DELETE ROLES
 WHERE ROLE_ID = 1001;
 
 drop table star_wars;
 drop table characters;
 
 select * from roles;
 select * from characters;
-- 
-- 이 문장을 실행하면 그 결과는 어떻게 되는가? 또한 그러한 결과가 나오는 이유는 
-- 무엇인지 설명해 보자.
-- 		integrity constraint (SCOTT.CHAR_ROLE_ID_FK) violated - child record found
-- 		에러 내용으로 characters테이블에 참조키로 묶여있기 때문에 삭제가 안된다.
	
-- ex12) characters에 character_name 인덱스 생성하기
create index characters_ix_01 on characters(character_name);

-- ex13) 상기작업들의 data dictionary를 조회
select * from user_indexes;

/* 연습문제 */
-- ex01) new_emp4를 생성, no(number), name(), sal(number)
create table new_emp4 (
	no number
, name varchar2(6)
, sal number
);
drop table new_emp4;
-- ex02) 데이터를 insert
--    1000, 'SMITH', 300
--    1001, 'ALLEN', 250
--    1002, 'KING', 430
--    1003, 'BLAKE', 220
--    1004, 'JAMES', 620
--    1005, 'MILLER', 810
insert into new_emp4 values(1000, 'SMITH', 300);
insert into new_emp4 values(1001, 'ALLEN', 250);
insert into new_emp4 values(1002, 'KING', 430);
insert into new_emp4 values(1003, 'BLAKE', 220);
insert into new_emp4 values(1004, 'JAMES', 620);
insert into new_emp4 values(1005, 'MILLER', 810);

select * from new_emp4;
-- ex03) name컬럼에 인덱스 생성
create index new_emp4_idx_01 on new_emp4(name);

-- ex04) 인덱스를 사용하지 않는 일반적인 SQL
/*
1) 데이터가 적을 경우(수천건 미만)에는 인덱스를 설정하지 않는 것이 오히려 성능에 좋다.
2) 검색보다 update, delete, insert가 빈번하게 일어나는 테이블에는 인덱스가 없는 게 오히려 
	 좋을 수가 있다.
3) 조회결과 전체 행의 15%이상인 경우에는 사용하지 않는 것이 좋다.
*/
















