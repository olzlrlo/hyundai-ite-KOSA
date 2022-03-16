drop table t1 purge;

create table t1(
    c1 int,
    c2 char(10)
);

insert into t1
    select level, 'dummy'
    from dual
    connect by level <= 10000;

commit;

/* 인덱스 생성 */
/* 고유한 값을 가진 c1으로 생성 */
create index t1_n1
on t1(c1);



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display);



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select * from
table(dbms_xplan.display('plan_table', null, 'typical', null));



/* 실행 쿼리 저장 */
explain plan
set statement_id = 'test' for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', 'test', 'typical', null));



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', null, 'basic'));



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', null, 'typical'));



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', null, 'all'));



/* 실행 쿼리 저장 */
explain plan for
    select /*+ qb_name(x) */ *
    from t1
    where c1 = 1 and c2 = 'dummy';
    
/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', null, 'all'));



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
/* 힌트 보여줌 - 실행 계획을 고정할 때 활용할 수 있으나, 고정은 좋은 방법이 아님*/
select *
from table(dbms_xplan.display('plan_table', null, 'outline'));



/* 실행 쿼리 저장 */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* 실행 계획 확인 */
select *
from table(dbms_xplan.display('plan_table', null, 'advanced'));
