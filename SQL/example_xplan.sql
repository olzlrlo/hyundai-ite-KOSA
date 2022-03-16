-- https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html

/*
    Hash Join
    
    Build Input 이후 Prove를 수행하는 조인 연산
    
    조인될 두 테이블 중 하나를 해시 테이블로 선정하여
    조인될 테이블의 조인 키 값을 해시 알고리즘으로 비교하여 매치되는 결과값을 얻는 방식
    
    비용 기반 옵티마이저를 사용할 때만 사용될 수 있는 조인 방식이며 '=' 비교를 통한 조인에서만 사용
    
*/

-- (0) Prerequisite SQL

drop table bricks purge;
drop table colours purge; 
drop table cuddly_toys purge;
drop table pens purge;

create table bricks (
  colour varchar2(10),
  shape  varchar2(10)
);

create table colours (
  colour        varchar2(10),
  rgb_hex_value varchar2(6)
);

create table cuddly_toys (
  toy_name varchar2(20),
  colour   varchar2(10)
);

create table pens (
  colour   varchar2(10),
  pen_type varchar2(10)
);

insert into cuddly_toys values ( 'Miss Snuggles', 'pink' ) ;
insert into cuddly_toys values ( 'Cuteasaurus', 'blue' ) ;
insert into cuddly_toys values ( 'Baby Turtle', 'green' ) ;
insert into cuddly_toys values ( 'Green Rabbit', 'green' ) ;
insert into cuddly_toys values ( 'White Rabbit', 'white' ) ;

insert into colours values ( 'red' , 'FF0000' ); 
insert into colours values ( 'blue' , '0000FF' ); 
insert into colours values ( 'green' , '00FF00' ); 

insert into bricks values ( 'red', 'cylinder' );
insert into bricks values ( 'blue', 'cube' );
insert into bricks values ( 'green', 'cube' );

insert into bricks
  select * from bricks;
  
insert into bricks
  select * from bricks;
  
insert into bricks
  select * from bricks;

insert into pens values ( 'black', 'ball point' );
insert into pens values ( 'black', 'permanent' );
insert into pens values ( 'blue', 'ball point' );
insert into pens values ( 'green', 'permanent' );
insert into pens values ( 'green', 'dry-wipe' );
insert into pens values ( 'red', 'permanent' );
insert into pens values ( 'red', 'dry-wipe' );
insert into pens values ( 'blue', 'permanent' );
insert into pens values ( 'blue', 'dry-wipe' );

commit;

exec dbms_stats.gather_table_stats ( null, 'pens' ) ;
exec dbms_stats.gather_table_stats ( null, 'colours' ) ;
exec dbms_stats.gather_table_stats ( null, 'bricks' ) ;
exec dbms_stats.gather_table_stats ( null, 'cuddly_toys' ) ;


-- (1) DBMS_XPlan으로 기본 계획 읽기

/* NULL을 전달하면 이 세션에서 마지막으로 실행된 SQL 문의 계획을 가져옴 */
/* Live SQL에서는 바인드 변수로 SQL_ID를 전달 가능 */

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor());


-- (2) SQL ID 찾기

/* V$SQL에서 ID를 찾을 수 있음 */
/* 각 문장마다 고유의 SQL ID 부여 */

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select sql_id, sql_text
from   v$sql
where  sql_text like '%bricks%join%colours%';

-- (3) DBMS_XPlan으로 SQL ID 활용하기

/* SQL ID를 알면 바로 DBMS_XPlan에 전달 가능*/ 
select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor('1jqgaskqzc3tq'));


/* SQL ID는 모르지만 쿼리의 text를 아는 경우, 아래 쿼리 사용 가능 */ 
select /* colours query */*
from colours;

select p.*  
from   v$sql s, table (  
  dbms_xplan.display_cursor (  
    s.sql_id, s.child_number, 'BASIC'  
  )  
) p  
where s.sql_text like '%colours query%';


-- (4) 예제: BRICKS에서 행을 가져오는 쿼리의 SQL ID 찾기

/* 쿼리 */
select sql_id
from   v$sql
where  sql_text like 'select *%bricks b%';

/* plan.sql 활용 */
select /* bricks_1 */ *
from bricks;

@plan -- bricks_1 입력


-- (5) 실행 계획 읽기
/*
    실행 계획 = 트리
    DB는 DFS(깊이 우선 검색)을 사용하여 탐색
    
    이 작업은 계획 상단의 SELECT 작업부터 시작하고, 최상단 잎으로 이동
    이 소스에서 데이터를 읽으면 부모로 이동
    
    이 시점에서 이 프로세스가 반복
    다음 방문하지 않은 잎을 찾기 위해 계획을 따라 내려감
    읽은 후, 행을 부모에게 전달
*/

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor());

/*
    위에서부터 시작해서(SELECT절), 트리를 따라 첫 번째 잎까지 이동
    이것은 COLOURS 테이블의 TABLE ACCESS FULL

    이 테이블의 행을 첫 번째 잎의 부모인 HASH JOIN에 전달
    1단계에서 다음 방문하지 않은 자식을 찾습니다.
    이것은 BRICKS 테이블의 TABLE ACCESS FULL
    
    이 테이블의 행을 부모인 HASH JOIN에게 전달
    1단계의 모든 자식에 접근했으므로, JOIN에서 살아남은 행을 SELECT 문에 전달
    클라이언트에 전달
*/


-- (6) 4개 테이블 조인 계획

select c.*, pen_type, shape, toy_name 
from   colours c
join   pens p
on     c.colour = p.colour
join   cuddly_toys t
on     c.colour = t.colour
join   bricks b
on     c.colour = b.colour;

select * 
from   table(dbms_xplan.display_cursor());

/*
    위에서부터 시작해서(SELECT절), 트리를 따라 첫 번째 잎까지 이동
    실행 계획 4단계에서 COLOURS 테이블의 TABLE ACCESS FULL

    이 테이블의 행을 첫 번째 잎의 부모(3단계의 HASH JOIN)에게 전달
    다음 방문하지 않은 자식 탐색
    이것은 5단계에서 CUDDLY_TOYS 테이블의 TABLE ACCESS FULL

    3단계에서 행을 HASH JOIN에 전달합
    3단계에는 하위 항목이 없으므로 3단계의 HASH JOIN에서 살아남은 행을 2단계의 HASH JOIN에 전달

    2단계의 다음 자식을 탐색
    6단계에서 PENS 테이블의 TABLE ACCESS FULL

    2단계에서 이 행을 HASH JOIN에 전달
    2단계에는 하위 항목이 없으므로 2단계의 HASH JOIN에서 살아남은 행을 1단계의 HASH JOIN에 전달

    모든 작업을 완료할 때까지 이 과정을 반복
    실행 계획 단계 ID에 액세스하는 전체 순서는 4, 3, 5, 3, 2, 6, 2, 1, 7, 1, 0
*/


-- (7) 복잡한 쿼리 계획 읽기

select c.colour, count(*)
from   colours c 
join   (
  select colour, shape from bricks
  union all
  select colour, toy_name from cuddly_toys
  union all
  select colour, pen_type from pens
) t
on     t.colour = c.colour
group  by c.colour;

select * 
from   table(dbms_xplan.display_cursor());


-- (8) View Rows Processed in the Plan
/*
    기본 계획은 형태만 보여줌
    계획이 양호한지 여부를 평가하려면 계획의 각 단계에서 흘러나오는 행 수를 확인해야 함
    
    이를 수행하려면 DBMS_XPLAN format 파라미터를 사용
    ROWSTATS를 사용하면 추정된 행 수와 실제 행 수가 각 단계에 추가
    
    원하는 실행 상세 내역 지정 가능
        LAST - 마지막 실행 통계만 표시
        ALL(기본값) - 모든 실행에 대한 누적 통계
*/

select /*+ gather_plan_statistics */*
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS LAST'));


-- (9) 예제: 모든 실행에 대한 누적 통계 구하기

select /*+ gather_plan_statistics */*
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS ALL'));


-- (10) The Starts Statistic
/*
    지금까지의 쿼리에서 DB는 실행 중에 각 테이블을 한 번 읽음
    일부 쿼리에서는 DB가 동일한 테이블을 여러 번 읽음

    이를 확인하려면 Row Stats에 포함된 Starts 열을 확인
    쿼리 실행 중 작업이 시작된 횟수를 나타냄

    이 쿼리는 Scalar 서브쿼리를 사용
    DB는 Colours 테이블의 각 행에 대해 이 작업을 한 번 실행 가능
    
*/
select /*+ gather_plan_statistics */c.rgb_hex_value,
       ( select count (*)
         from   bricks b
         where  b.colour = c.colour 
       ) brick#
from   colours c;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS LAST'));

/*
    이 계획에서는 최상위 잎 우선 읽기 규칙도 깨짐
    계획에서 BROCK은 COLOURS 위에 표시
    그러나 COLOURS 테이블에서 행을 받음
    따라서 DB는 BRICKS보다 COLUES를 먼저 읽어야 함

    실행 계획에는 특이한 경우가 많음
*/


-- (11) 예제: BRICK에 한 번만 접근하도록 (10)을 수정
/* 위의 서브쿼리를 JOIN으로 수정 */

select /*+ gather_plan_statistics */c.rgb_hex_value
from   colours c, bricks b
where c.colour(+)= b.colour
group by c.rgb_hex_value;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS LAST'));