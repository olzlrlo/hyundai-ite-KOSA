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

/* �ε��� ���� */
/* ������ ���� ���� c1���� ���� */
create index t1_n1
on t1(c1);



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display);



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select * from
table(dbms_xplan.display('plan_table', null, 'typical', null));



/* ���� ���� ���� */
explain plan
set statement_id = 'test' for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', 'test', 'typical', null));



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', null, 'basic'));



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', null, 'typical'));



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', null, 'all'));



/* ���� ���� ���� */
explain plan for
    select /*+ qb_name(x) */ *
    from t1
    where c1 = 1 and c2 = 'dummy';
    
/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', null, 'all'));



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
/* ��Ʈ ������ - ���� ��ȹ�� ������ �� Ȱ���� �� ������, ������ ���� ����� �ƴ�*/
select *
from table(dbms_xplan.display('plan_table', null, 'outline'));



/* ���� ���� ���� */
explain plan for
    select *
    from t1
    where c1 = 1 and c2 = 'dummy';

/* ���� ��ȹ Ȯ�� */
select *
from table(dbms_xplan.display('plan_table', null, 'advanced'));
