/* 1. 강한 타입은 반환되는 컬럼의 개수와 타입만 일치하면 모든 SELECT문에 대해 OPEN 가능 */

CREATE OR REPLACE PROCEDURE sp_strong_type_cursor_variable
IS
    TYPE emp_record_type IS RECORD(empno emp.empno%TYPE, ename emp.ename%TYPE, sal emp.sal%TYPE);

    TYPE emp_cursor_type IS REF CURSOR
    RETURN emp_record_type;

    v_emprec emp_record_type;
    v_empcur emp_cursor_type; -- 강한 타입의 커서 변수
    
BEGIN
    OPEN v_empcur -- 첫 번째 SQL문에 대한 커서 변수를 OPEN
        FOR
            SELECT empno, ename, sal 
            FROM emp 
            WHERE deptno = 10;
    
        LOOP
            FETCH v_empcur INTO v_emprec; -- Active Set에서 결과 행을 추출하고, v_emprec 변수에 대입
            EXIT WHEN v_empcur%notfound;
            dbms_output.put_line('EMPNO='||v_emprec.empno||', ENAME='||v_emprec.ename||', SAL='||v_emprec.sal);
        END LOOP;
    CLOSE v_empcur;
    dbms_output.put_line(' ');
  
    OPEN v_empcur -- 두 번째 SQL문에 대한 커서 변수를 OPEN
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



/* 2. 커서 변수는 서브 프로그램의 매개 변수로 사용 가능 */

CREATE OR REPLACE PROCEDURE sp_cusor_variable_parameter
IS
    TYPE emp_record_type IS RECORD(empno emp.empno%TYPE, ename emp.ename%TYPE);

    TYPE emp_cursor_type IS REF CURSOR
    RETURN emp_record_type; 

    v_empcur emp_cursor_type; -- 강한 타입의 커서 변수
  
PROCEDURE print_emp(a_empcur IN emp_cursor_type) -- 로컬 서브프로그램
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



-- 약한 타입의 커서 변수는 반환형이 다른 쿼리에 대해서도 사용 가능
CREATE OR REPLACE PROCEDURE sp_weak_type_cursor_variable
IS
    v_cursor   SYS_REFCURSOR;  /* 약한 타입의 커서 변수 */
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
            FETCH a_cursor INTO v_deptrec; -- dept 테이블의 세 칼럼을 레코드에 담음
            EXIT WHEN a_cursor%notfound;
            dbms_output.put_line('DEPTNO='||v_deptrec.deptno||', DNAME='||v_deptrec.dname||', LOC=' ||v_deptrec.loc);
        END LOOP;
    END IF;
END;

BEGIN
    -- DEPT 테이블 출력
    v_selector := 'D';
    v_deptno := 10;
    open_cursor(v_cursor, v_selector, v_deptno); -- 커서 OPEN
    print_cursor(v_cursor, v_selector); -- 커서 출력
    CLOSE v_cursor;
  
    dbms_output.put_line('----');

    -- DEPT 테이블 출력
    v_selector := 'E';
    v_deptno := 10;
    open_cursor(v_cursor, v_selector, v_deptno); -- 커서 OPEN
    print_cursor(v_cursor, v_selector); -- 커서 출력
    CLOSE v_cursor;
END;
/

EXEC sp_weak_type_cursor_variable;
