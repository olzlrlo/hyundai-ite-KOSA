-- https://livesql.oracle.com/apex/livesql/file/tutorial_JN0V7TL1WLTHR9MSJKJ4MAXQF.html

/*
    Hash Join
    
    Build Input ���� Prove�� �����ϴ� ���� ����
    
    ���ε� �� ���̺� �� �ϳ��� �ؽ� ���̺�� �����Ͽ�
    ���ε� ���̺��� ���� Ű ���� �ؽ� �˰������� ���Ͽ� ��ġ�Ǵ� ������� ��� ���
    
    ��� ��� ��Ƽ�������� ����� ���� ���� �� �ִ� ���� ����̸� '=' �񱳸� ���� ���ο����� ���
    
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


-- (1) DBMS_XPlan���� �⺻ ��ȹ �б�

/* NULL�� �����ϸ� �� ���ǿ��� ���������� ����� SQL ���� ��ȹ�� ������ */
/* Live SQL������ ���ε� ������ SQL_ID�� ���� ���� */

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor());


-- (2) SQL ID ã��

/* V$SQL���� ID�� ã�� �� ���� */
/* �� ���帶�� ������ SQL ID �ο� */

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select sql_id, sql_text
from   v$sql
where  sql_text like '%bricks%join%colours%';

-- (3) DBMS_XPlan���� SQL ID Ȱ���ϱ�

/* SQL ID�� �˸� �ٷ� DBMS_XPlan�� ���� ����*/ 
select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor('1jqgaskqzc3tq'));


/* SQL ID�� ������ ������ text�� �ƴ� ���, �Ʒ� ���� ��� ���� */ 
select /* colours query */*
from colours;

select p.*  
from   v$sql s, table (  
  dbms_xplan.display_cursor (  
    s.sql_id, s.child_number, 'BASIC'  
  )  
) p  
where s.sql_text like '%colours query%';


-- (4) ����: BRICKS���� ���� �������� ������ SQL ID ã��

/* ���� */
select sql_id
from   v$sql
where  sql_text like 'select *%bricks b%';

/* plan.sql Ȱ�� */
select /* bricks_1 */ *
from bricks;

@plan -- bricks_1 �Է�


-- (5) ���� ��ȹ �б�
/*
    ���� ��ȹ = Ʈ��
    DB�� DFS(���� �켱 �˻�)�� ����Ͽ� Ž��
    
    �� �۾��� ��ȹ ����� SELECT �۾����� �����ϰ�, �ֻ�� ������ �̵�
    �� �ҽ����� �����͸� ������ �θ�� �̵�
    
    �� �������� �� ���μ����� �ݺ�
    ���� �湮���� ���� ���� ã�� ���� ��ȹ�� ���� ������
    ���� ��, ���� �θ𿡰� ����
*/

select *
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor());

/*
    ���������� �����ؼ�(SELECT��), Ʈ���� ���� ù ��° �ٱ��� �̵�
    �̰��� COLOURS ���̺��� TABLE ACCESS FULL

    �� ���̺��� ���� ù ��° ���� �θ��� HASH JOIN�� ����
    1�ܰ迡�� ���� �湮���� ���� �ڽ��� ã���ϴ�.
    �̰��� BRICKS ���̺��� TABLE ACCESS FULL
    
    �� ���̺��� ���� �θ��� HASH JOIN���� ����
    1�ܰ��� ��� �ڽĿ� ���������Ƿ�, JOIN���� ��Ƴ��� ���� SELECT ���� ����
    Ŭ���̾�Ʈ�� ����
*/


-- (6) 4�� ���̺� ���� ��ȹ

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
    ���������� �����ؼ�(SELECT��), Ʈ���� ���� ù ��° �ٱ��� �̵�
    ���� ��ȹ 4�ܰ迡�� COLOURS ���̺��� TABLE ACCESS FULL

    �� ���̺��� ���� ù ��° ���� �θ�(3�ܰ��� HASH JOIN)���� ����
    ���� �湮���� ���� �ڽ� Ž��
    �̰��� 5�ܰ迡�� CUDDLY_TOYS ���̺��� TABLE ACCESS FULL

    3�ܰ迡�� ���� HASH JOIN�� ������
    3�ܰ迡�� ���� �׸��� �����Ƿ� 3�ܰ��� HASH JOIN���� ��Ƴ��� ���� 2�ܰ��� HASH JOIN�� ����

    2�ܰ��� ���� �ڽ��� Ž��
    6�ܰ迡�� PENS ���̺��� TABLE ACCESS FULL

    2�ܰ迡�� �� ���� HASH JOIN�� ����
    2�ܰ迡�� ���� �׸��� �����Ƿ� 2�ܰ��� HASH JOIN���� ��Ƴ��� ���� 1�ܰ��� HASH JOIN�� ����

    ��� �۾��� �Ϸ��� ������ �� ������ �ݺ�
    ���� ��ȹ �ܰ� ID�� �׼����ϴ� ��ü ������ 4, 3, 5, 3, 2, 6, 2, 1, 7, 1, 0
*/


-- (7) ������ ���� ��ȹ �б�

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
    �⺻ ��ȹ�� ���¸� ������
    ��ȹ�� ��ȣ���� ���θ� ���Ϸ��� ��ȹ�� �� �ܰ迡�� �귯������ �� ���� Ȯ���ؾ� ��
    
    �̸� �����Ϸ��� DBMS_XPLAN format �Ķ���͸� ���
    ROWSTATS�� ����ϸ� ������ �� ���� ���� �� ���� �� �ܰ迡 �߰�
    
    ���ϴ� ���� �� ���� ���� ����
        LAST - ������ ���� ��踸 ǥ��
        ALL(�⺻��) - ��� ���࿡ ���� ���� ���
*/

select /*+ gather_plan_statistics */*
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS LAST'));


-- (9) ����: ��� ���࿡ ���� ���� ��� ���ϱ�

select /*+ gather_plan_statistics */*
from   bricks b
join   colours c
on     b.colour = c.colour;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS ALL'));


-- (10) The Starts Statistic
/*
    ���ݱ����� �������� DB�� ���� �߿� �� ���̺��� �� �� ����
    �Ϻ� ���������� DB�� ������ ���̺��� ���� �� ����

    �̸� Ȯ���Ϸ��� Row Stats�� ���Ե� Starts ���� Ȯ��
    ���� ���� �� �۾��� ���۵� Ƚ���� ��Ÿ��

    �� ������ Scalar ���������� ���
    DB�� Colours ���̺��� �� �࿡ ���� �� �۾��� �� �� ���� ����
    
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
    �� ��ȹ������ �ֻ��� �� �켱 �б� ��Ģ�� ����
    ��ȹ���� BROCK�� COLOURS ���� ǥ��
    �׷��� COLOURS ���̺��� ���� ����
    ���� DB�� BRICKS���� COLUES�� ���� �о�� ��

    ���� ��ȹ���� Ư���� ��찡 ����
*/


-- (11) ����: BRICK�� �� ���� �����ϵ��� (10)�� ����
/* ���� ���������� JOIN���� ���� */

select /*+ gather_plan_statistics */c.rgb_hex_value
from   colours c, bricks b
where c.colour(+)= b.colour
group by c.rgb_hex_value;

select * 
from   table(dbms_xplan.display_cursor(format => 'ROWSTATS LAST'));