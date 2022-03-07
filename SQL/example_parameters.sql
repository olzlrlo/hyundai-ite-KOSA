-- (1) IN mode 예제

create or replace function addNumberFunc
(
    a in number, 
    b in number
)
    return number
is
begin
    return a + b;
end;
/

set serveroutput on
set verify off
set autoprint on

var g_result number
exec :g_result := addNumberFunc(&no1, &no2)

exec dbms_output.put_line(addNumberFunc(&no1, &no2))

select addNumberFunc(&no1, &no2) from dual;

begin
    if addNumberFunc(&no1, &no2) = 125 then
        dbms_output.put_line('Correct!');
    else
        dbms_output.put_line('Wrong!');
    end if;
end;
/


-- (2) OUT mode 예제

create or replace procedure emp_select_by_empno
(
    p_empno in  emp.empno%type,
    p_ename out emp.ename%type,
    p_sal   out emp.sal%type,
    p_job   out emp.job%type
)
is
begin
    select ename, sal, job
    into p_ename, p_sal, p_job 
    from emp
    where empno = p_empno;
end;
/

  -- 테스트 1
var g_ename varchar2(30)
var g_sal   number
var g_job   varchar2(30)  

exec emp_select_by_empno(&sv_empno, :g_ename, :g_sal, :g_job)

  -- 테스트 2
declare
    v_ename emp.ename%type;
    v_sal   emp.sal%type;
    v_job   emp.job%type;
begin
    emp_select_by_empno(&sv_empno, v_ename, v_sal, v_job);

    dbms_output.put_line(v_ename);
    dbms_output.put_line(v_sal);
    dbms_output.put_line(v_job); 
end;
/


-- INOUT mode 예제

create or replace procedure sp_in_out_example
(a in out varchar2)
is 
begin
    a := substr(a,1,3)||'-'||substr(a, 4, 4)||'-'||substr(a, 8);
end;
/ 

-- 테스트 1
var g_telno varchar2(50)
exec :g_telno := '01023238974'
exec sp_in_out_example(:g_telno);

-- 테스트 2
declare
    telno varchar2(50) := '01023238974';
begin
    sp_in_out_example(telno);
    dbms_output.put_line(telno);    
end;
/

