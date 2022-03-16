-- Case 1

drop table t_emp purge;
drop table t_dept purge;
drop table t_nation purge;

create table t_nation(
    id   varchar2(10) primary key,
    name varchar2(10)
);

create table t_dept(
    deptno number(2) primary key,
    dname  varchar2(10),
    loc    varchar2(10)
);

create table t_emp(
    empno     number(4) primary key,
    ename     varchar2(10),
    sal       number(7, 2),
    deptno    number(2)    references t_dept(deptno), /* 1:M */
    nation_id varchar2(10) references t_nation(id)    /* 1:M */
);


-- Case 2

drop table t_emp purge;
drop table t_dept purge;
drop table t_nation purge;

create table t_nation(
    id   varchar2(10) primary key,
    name varchar2(10)
);

create table t_dept(
    deptno number(2) primary key,
    dname  varchar2(10),
    loc    varchar2(10)
);

create table t_emp(
    empno     number(4),
    ename     varchar2(10),
    sal       number(7, 2),
    deptno    number(2)    references t_dept(deptno), /* 1:M */
    nation_id varchar2(10) references t_nation(id),   /* 1:M */
    primary key(empno, deptno) /* 복합 PK */
);


-- Case 3

drop table account purge;
drop table bank purge;

create table bank(
    id   varchar2(10),
    type varchar2(10),
    name varchar2(10),
    primary key(id, type), /* 복합 PK */
    check(name is not null)
);

create table account(
    id        varchar2(10),
    amt       number,
    bank_id   varchar2(10),
    bank_type varchar2(10),
    primary key(id),
    check(amt is not null),
    foreign key(bank_id, bank_type) references bank(id, type) /* 1:M */
);


-- Case 4

drop table account purge;
drop table bank purge;

create table bank(
    id   varchar2(10),
    type varchar2(10),
    name varchar2(10),
    primary key(id, type), /* 복합 PK */
    check(name is not null)
);


create table account(
    id        varchar2(10),
    amt       number,
    bank_id   varchar2(10),
    bank_type varchar2(10),
    primary key(id, bank_id, bank_type), /* 복합 PK */
    check(amt is not null),
    foreign key(bank_id, bank_type) references bank(id, type) /* 1:M */
);


-- Case 5

drop table casting purge;
drop table movie purge;
drop table actor purge;

create table actor(
    id   varchar2(10) primary key,
    name varchar2(10)
);

create table movie(
    id   varchar2(10) primary key,
    name varchar2(10)
);

create table casting(
    actor_id varchar2(10) references actor(id), /* 1:M */
    movie_id varchar2(10) references movie(id), /* 1:M */
    primary key(actor_id, movie_id) /* 복합 PK */
);

/* CASTING 테이블을 Index-organized Table로 생성 */

create table casting2(
    actor_id varchar2(10) references actor(id),
    movie_id varchar2(10) references movie(id),
    primary key(actor_id, movie_id)
)ORGANIZATION INDEX ;


-- Case 6

drop table d purge;
drop table c purge;
drop table b purge;
drop table a purge;

create table a(
    a1 number,
    a2 number,
    primary key(a1)
);

create table b(
    b1 number,
    b2 number,
    a1 number,
    primary key(b1, a1), /* 복합 PK */
    foreign key(a1) references a(a1) /* 1:M */
);

create table c(
    c1 number,
    c2 number,
    b1 number,
    a1 number,
    primary key(c1, b1, a1), /* 복합 PK */
    foreign key(b1, a1) references b(b1, a1) /* 1:M */
);

create table d(
    d1 number,
    d2 number,
    c1 number,
    b1 number, 
    a1 number,
    primary key(d1, c1, b1, a1), /* 복합 PK */
    foreign key(c1, b1, a1) references c(c1, b1, a1) /* 1:M */
);

/* 테이블 간 조인 */
    
select * 
from a, b
where a.a1 = b.a1;

select *
from b, c
where b.b1 = c.b1 and b.a1 = c.a1;

select *
from c, d
where c.c1 = d.c1 and c.b1 = d.b1 and c.a1 = d.a1;

select *
from a, d
where a.a1 = d.a1;


-- 예제) HR Schema에서 Europe에 있는 부서를 쿼리 

/* 비식별자 관계로 설정되어 있어 아래와 같이 쿼리 */

    /* 서브쿼리 활용 */
select *                    /* 유럽에 있는 나라의 부서 */
from departments
where LOCATION_ID in (      /* 유럽에 있는 나라의 위치 */
  select LOCATION_ID
  from locations
  where COUNTRY_ID in (     /* 유럽에 있는 나라 */
      select COUNTRY_ID
      from countries 
      where REGION_ID in ( /* 유럽 */
          select REGION_ID 
          from regions
          where REGION_NAME = 'Europe')));

    /* 조인 활용 */
select d.*
from departments d JOIN locations l
                   ON d.LOCATION_ID = l.LOCATION_ID
                 JOIN countries c
                   ON l.COUNTRY_ID  = c.COUNTRY_ID
                 JOIN regions r
                   ON c.REGION_ID = r.REGION_ID
where r.REGION_NAME = 'Europe';


/* 식별자 관계로 설정되면 아래와 같이 쿼리 */

select *
from departments
where REGION_ID in (
  select REGION_ID 
  from regions
  where REGION_NAME = 'Europe');

select *
from departments d JOIN regions r
                   ON d.REGION_ID = r.REGION_ID 
where r.REGION_NAME = 'Europe';