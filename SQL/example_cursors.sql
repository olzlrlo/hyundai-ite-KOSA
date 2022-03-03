-- Implicit Cursor �Ӽ� ��� ����

DROP TABLE emp2 PURGE;
CREATE TABLE emp2 
AS 
SELECT * FROM emp;

BEGIN
    UPDATE emp2
    SET sal = sal * 1.3
    WHERE deptno = 70;
    
    IF SQL%rowcount = 0 THEN
        p.p('������ ���� �����ϴ�.');
    ELSE
        p.p(SQL%rowcount||' ���� �����Ǿ����ϴ�');
    END IF;
    
    DELETE FROM emp2
    WHERE deptno = 20;

    IF SQL%rowcount = 0 THEN
        p.p('������ ���� �����ϴ�.');
    ELSE
        p.p(SQL%rowcount||' ���� �����Ǿ����ϴ�');
    END IF;
END;
/


-- Explicit Cursor �Ӽ� ��� ���� (declare -> open -> fetch -> close)

CREATE OR REPLACE PROCEDURE p1(a emp.deptno%TYPE)
IS
    CURSOR emp_cursor
    IS
        SELECT empno, ename, sal, job, hiredate
        FROM emp
        WHERE deptno = a
        ORDER BY sal DESC;

    r emp_cursor%rowtype;
BEGIN
    IF NOT(emp_cursor%isopen) THEN
        OPEN emp_cursor;  /* ���� ���ο� active set�� ���� */ 
    END IF;

    LOOP
        FETCH emp_cursor INTO r;
        EXIT WHEN emp_cursor%notfound;
        p.p(r.empno||' '||r.sal||' '||r.JOB);
    END LOOP;

    CLOSE emp_cursor;
END;
/
EXEC p1(10)
EXEC p1(30)


/* Cursor for loop */
CREATE OR REPLACE PROCEDURE p1(a emp.deptno%TYPE)
IS
    CURSOR emp_cursor
    IS
        SELECT empno, ename, sal, job, hiredate
        FROM emp
        WHERE deptno = a
        ORDER BY sal DESC;
BEGIN
    FOR R IN emp_cursor LOOP  /* open, fetch */
    P.P(R.empno||' '||R.sal||' '||R.JOB);
    END LOOP;         /* close */
END;
/
EXEC p1(10)
EXEC p1(30)


/* ���������� �̿��� Cursor for loop */
CREATE OR REPLACE PROCEDURE p1(a emp.deptno%TYPE)
IS
BEGIN
    FOR r IN (SELECT empno, ename, sal, job, hiredate
        FROM emp
        WHERE deptno = a
        ORDER BY sal DESC) LOOP
    p.p(r.empno||' '||r.sal||' '||r.JOB);
    END LOOP;
END;
/
EXEC p1(10)
EXEC p1(30)






