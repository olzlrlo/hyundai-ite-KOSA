drop table accounts purge;

create table accounts(
     ano varchar2(10),
     owner varchar2(10),
     balance number
);

alter table accounts
    add constraint accounts_ano_pk primary key(ano);

create or replace package accounts_pack
is
    procedure accounts_insert
    (
        p_ano accounts.ano%type,
        p_owner accounts.owner%type,
        p_balance accounts.balance%type
    );

    procedure accounts_plus_update
    (
        p_ano accounts.ano%type,
        p_balance accounts.balance%type
    );

    procedure accounts_minus_update
    (
        p_ano accounts.ano%type,
        p_balance accounts.balance%type
    );

    procedure accounts_delete
        (p_ano accounts.ano%type);

    procedure accounts_select_all
        (p_cursor out sys_refcursor);

    function is_account_exists
        (p_ano accounts.ano%type)
        return varchar2;
end;
/

create or replace package body accounts_pack
is
    function balalnce_check
        (a accounts.balance%type)
        return boolean
    is
    begin
        if a < 1000 then
            return false;
        else
            return true;
        end if;
    end;

    procedure accounts_insert
    (
        p_ano accounts.ano%type,
        p_owner accounts.owner%type,
        p_balance accounts.balance%type
    )
    is
    begin
        if balalnce_check(p_balance) then
            insert into accounts(ano, owner, balance)
            values(p_ano, p_owner, p_balance);
        end if;

      dbms_output.put_line('1000원 이상 설정하셔야 합니다!');
    commit;
    end;

    procedure accounts_plus_update
    (
        p_ano     accounts.ano%type,
        p_balance accounts.balance%type
    )

    is
    begin
        update accounts
        set balance = balance + p_balance
        where ano = p_ano;

    commit;
    end;

    procedure accounts_minus_update
    (
        p_ano accounts.ano%type,
        p_balance accounts.balance%type
     )
    is
    begin
        update accounts
        set balance = balance - p_balance
        where ano = p_ano;

    commit;
    end;

    procedure accounts_delete
        (p_ano accounts.ano%type)
    is
    begin
        delete from accounts
        where ano = p_ano;

    commit;
    end;

    procedure accounts_select_all
        (p_cursor out sys_refcursor)
    is
    begin
        open p_cursor for
        select *
        from accounts;
    end;

    function is_account_exists
        (p_ano accounts.ano%type)
        return varchar2
    is
        v_ret varchar2(1);
    begin
        select 'x' into v_ret
        from accounts
        where ano = p_ano;

        if v_ret is not null then
            return 'true';
        end if;
    exception
        when no_data_found then
            return 'false';
    end;
end;
/

set verify off
set serveroutput on

truncate table accounts;

select * from accounts;

exec accounts_pack.accounts_insert('111-111', '나자바', 100)
exec accounts_pack.accounts_insert('111-111', '나자바', 20000)
exec accounts_pack.accounts_insert('222-222', '토레타', 20000)
exec accounts_pack.accounts_insert('333-333', '제임스', 10000)
select * from accounts;

exec accounts_pack.accounts_plus_update('111-111', 10000)
select * from accounts;

exec accounts_pack.accounts_minus_update('111-111', 5000)
select * from accounts;

exec accounts_pack.accounts_delete('111-111')
select * from accounts;

declare
    v_cursor sys_refcursor;
    accounts_rec accounts%rowtype;
begin
    accounts_pack.accounts_select_all(v_cursor);

    loop
        fetch v_cursor into accounts_rec;
        exit when v_cursor%notfound;
        dbms_output.put_line('-------------');
        dbms_output.put_line(accounts_rec.ano);
        dbms_output.put_line(accounts_rec.owner);
        dbms_output.put_line(accounts_rec.balance);
    end loop;

    close v_cursor;
end;
/

  exec dbms_output.put_line(accounts_pack.is_account_exists('222-222'))
  exec dbms_output.put_line(accounts_pack.is_account_exists('555-555'))