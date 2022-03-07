-- (1) when name then

create or replace procedure p1(a number, b number)   
is
begin
    p.p(a/b);
exception
    when zero_divide then
        p.p('0���� ���� �� �����ϴ�!');
end;
/

exec p1(100, 2);  -- ����
exec p1(100, 0);  -- ����


-- (2) put the name to exception then handling

drop table t1 purge;
create table t1 (no number not null);

/* ���� �߻�: NULL ���� �Ұ� */
create or replace procedure  insert_t1(a number)
is
begin
    insert into t1 values(a);
end;
/

exec insert_t1(1000);
exec insert_t1(Null);

/* ���� ���� */
create or replace procedure insert_t1(a number)
is
    e_null exception;
    pragma exception_init(e_null, -1400);
begin
    insert into t1 values(a);
exception
    when e_null then
        p.p('Null ���� �Է��� �� �����ϴ�!');
end;
/

exec insert_t1(1000);
exec insert_t1(Null);

/* ���� ���� */
create or replace package pack_exceptions
is
    e_null exception;
    pragma exception_init(e_null, -1400);
end;
/

create or replace procedure insert_t1(a number)
is
begin
    insert into t1 values(a);
exception
    when pack_exceptions.e_null then
        p.p('Null ���� �Է��� �� �����ϴ�!');
end;
/

exec insert_t1(1000);
exec insert_t1(Null);


-- (3) when others then
drop table t1 purge;
create table t1 (no number not null);

/* ���� ���� */
create or replace procedure insert_t1(a number)
is
begin
    insert into t1 values(a);
exception
    when others then
        p.p(sqlcode);
        p.p(sqlerrm);
end;
/

exec insert_t1(1000);
exec insert_t1(Null);

/* error table ���� */
drop table t_errors purge;

create table t_errors(
    error_date      date,
    subprogram_name varchar2(30),
    error_code      varchar2(60),
    error_message   varchar2(60)
);

create or replace procedure insert_t1(a number)
is
    v_error_code    varchar2(60);
    v_error_message varchar2(60);
begin
    insert into t1 values(a);
exception
    when others then
        v_error_code := substr(sqlcode, 1, 30);
        v_error_message := substr(sqlerrm, 1, 30);

    insert into t_errors
    values(sysdate, 'insert_t1', v_error_code, v_error_message);
end;
/

exec insert_t1(1000);
exec insert_t1(Null);

select * from t1;
select * from t_errors;

/* */ 
drop table t_errors purge;

create table t_errors(
    error_date      date,
    subprogram_name varchar2(30),
    error_code      varchar2(60),
    error_message   varchar2(60)
);

create or replace procedure insert_error_messages
(
    error_date      in date,
    subprogram_name in varchar2,
    error_code      in varchar2,
    error_message   in varchar2
)
is
    v_error_code    varchar2(60);
    v_error_message varchar2(60);
begin
    v_error_code := substr(error_code, 1, 30);
    v_error_message := substr(error_message, 1, 30);

    insert into t_errors
    values(sysdate, subprogram_name,  v_error_code, v_error_message );
end;
/

create or replace procedure insert_t1(a number)
is
begin
    insert into t1 values(a);
exception
    when others then
        insert_error_messages(sysdate, 'insert_t1', sqlcode, sqlerrm);
end;
/

exec insert_t1(1000);
exec insert_t1(Null);

select * from t1;
select * from t_errors;

-- (4) declare, raise, handling
create or replace procedure p1(a number)
is
    v_sal emp.sal%type;
    e_too_low exception;
begin
    select sal into v_sal
    from emp
    where empno = a;
    
    if v_sal < 1000 then
        raise e_too_low;
    end if;
    
    p.p(a||' ����� �޿��� '||v_sal||'�Դϴ�.');

exception
    when e_too_low then
        p.p(a||' ����� �޿��� ���� �޿� �̸��Դϴ�. Ȯ���غ�����!');
end;
/

exec p1(7788)
exec p1(7369)


--(5) raise_application_error procedure

/* ���� */ 
create or replace procedure p1(a number)
is
    v_sal emp.sal%type;
begin
    select sal into v_sal
    from emp
    where empno = a;

    if v_sal < 1000 then
        RAISE_APPLICATION_ERROR(-20111, a||' ����� �޿��� ���� �޿� �̸��Դϴ�. Ȯ���غ�����!');
    end if;

    p.p(a||' ����� �޿��� '||v_sal||'�Դϴ�.');
end;
/

exec p1(7369)


/* ���� */ 
create or replace procedure p1(a number)
is
    v_sal emp.sal%type;
    e_too_null exception;
    pragma exception_init(e_too_null, -20111);
begin
    select sal into v_sal
    from emp
    where empno = a;

    if v_sal < 1000 then
        RAISE_APPLICATION_ERROR(-20111, a||' ����� �޿��� ���� �޿� �̸��Դϴ�. Ȯ���غ�����!');
    end if;

    p.p(a||' ����� �޿��� '||v_sal||'�Դϴ�.');
exception
    when  e_too_null then
    p.p('���� �߻�');
end;
/

exec p1(7369)