/* 1. ���� Ÿ���� ��ȯ�Ǵ� �÷��� ������ Ÿ�Ը� ��ġ�ϸ� ��� SELECT���� ���� OPEN ���� */

CREATE OR REPLACE PROCEDURE sp_strong_type_cursor_variable
IS
    TYPE emp_record_type IS RECORD(empno emp.empno%TYPE, ename emp.ename%TYPE, sal emp.sal%TYPE);

    TYPE emp_cursor_type IS REF CURSOR
    RETURN emp_record_type;

    v_emprec emp_record_type;
    v_empcur emp_cursor_type; -- ���� Ÿ���� Ŀ�� ����
    
BEGIN
    OPEN v_empcur -- ù ��° SQL���� ���� Ŀ�� ������ OPEN
        FOR
            SELECT empno, ename, sal 
            FROM emp 
            WHERE deptno = 10;
    
        LOOP
            FETCH v_empcur INTO v_emprec; -- Active Set���� ��� ���� �����ϰ�, v_emprec ������ ����
            EXIT WHEN v_empcur%notfound;
            dbms_output.put_line('EMPNO='||v_emprec.empno||', ENAME='||v_emprec.ename||', SAL='||v_emprec.sal);
        END LOOP;
    CLOSE v_empcur;
    dbms_output.put_line(' ');
  
    OPEN v_empcur -- �� ��° SQL���� ���� Ŀ�� ������ OPEN
        FOR
            SELECT empno, ename, sal+nvl(comm, 0)
            FROM emp
            WHERE deptno = 20;
        LOOP
            FETCH v_empcur INTO v_emprec;
            EXIT WHEN v_empcur%notfound;
            dbms_output.put_line('EMPNO='||v_emprec.empno||', ENAME='||v_emprec.ename||', SAL='||v_emprec.sal);
        END LOOP;
    CLOSE v_empcur;
END;
/

EXEC sp_strong_type_cursor_variable;



/* 2. Ŀ�� ������ ���� ���α׷��� �Ű� ������ ��� ���� */

CREATE OR REPLACE PROCEDURE sp_cusor_variable_parameter
IS
    TYPE emp_record_type IS RECORD(empno emp.empno%TYPE, ename emp.ename%TYPE);

    TYPE emp_cursor_type IS REF CURSOR
    RETURN emp_record_type; 

    v_empcur emp_cursor_type; -- ���� Ÿ���� Ŀ�� ����
  
PROCEDURE print_emp(a_empcur IN emp_cursor_type) -- ���� �������α׷�
IS   
    v_emprec emp_record_type;
BEGIN
    LOOP
        FETCH a_empcur INTO v_emprec;
        EXIT WHEN a_empcur%notfound;
        dbms_output.put_line('EMPNO=' ||v_emprec.empno||', ENAME=' || v_emprec.ename);
    END LOOP;
END;

BEGIN
    OPEN v_empcur 
    FOR
        SELECT empno, ename 
        FROM emp;

    print_emp(v_empcur);
    CLOSE v_empcur;
END;
/

EXEC sp_cusor_variable_parameter;



-- ���� Ÿ���� Ŀ�� ������ ��ȯ���� �ٸ� ������ ���ؼ��� ��� ����
CREATE OR REPLACE PROCEDURE sp_weak_type_cursor_variable
IS
    v_cursor   SYS_REFCURSOR;  /* ���� Ÿ���� Ŀ�� ���� */
    v_selector CHAR;
    v_deptno   NUMBER;
  
PROCEDURE open_cursor(a_cursor IN OUT SYS_REFCURSOR, a_selector IN CHAR, a_deptno NUMBER)
IS
BEGIN
    IF a_selector = 'E' THEN
        OPEN a_cursor FOR SELECT * FROM emp  WHERE deptno = a_deptno;
    ELSE
        OPEN a_cursor FOR SELECT * FROM dept WHERE deptno = a_deptno;
    END IF;
END;

PROCEDURE print_cursor(a_cursor IN OUT SYS_REFCURSOR, a_selector IN CHAR)
IS
    v_emprec  emp%rowtype;
    v_deptrec dept%rowtype;
BEGIN
    IF a_selector = 'E' THEN
        LOOP
            FETCH a_cursor INTO v_emprec;
            EXIT WHEN a_cursor%notfound;
            dbms_output.put_line('EMPNO='||v_emprec.empno||', ENAME='||v_emprec.ename||', JOB='||v_emprec.JOB  ||', SAL='  ||v_emprec.sal);
        END LOOP;
    ELSE
        LOOP
            FETCH a_cursor INTO v_deptrec; -- dept ���̺��� �� Į���� ���ڵ忡 ����
            EXIT WHEN a_cursor%notfound;
            dbms_output.put_line('DEPTNO='||v_deptrec.deptno||', DNAME='||v_deptrec.dname||', LOC=' ||v_deptrec.loc);
        END LOOP;
    END IF;
END;

BEGIN
    -- DEPT ���̺� ���
    v_selector := 'D';
    v_deptno := 10;
    open_cursor(v_cursor, v_selector, v_deptno); -- Ŀ�� OPEN
    print_cursor(v_cursor, v_selector); -- Ŀ�� ���
    CLOSE v_cursor;
  
    dbms_output.put_line('----');

    -- DEPT ���̺� ���
    v_selector := 'E';
    v_deptno := 10;
    open_cursor(v_cursor, v_selector, v_deptno); -- Ŀ�� OPEN
    print_cursor(v_cursor, v_selector); -- Ŀ�� ���
    CLOSE v_cursor;
END;
/

EXEC sp_weak_type_cursor_variable;
