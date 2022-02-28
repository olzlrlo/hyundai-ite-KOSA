-- (1) ½Ç½À¿ë Å×ÀÌºí »ý¼º

DROP TABLE books PURGE;

CREATE TABLE books(
no NUMBER(10) GENERATED AS IDENTITY,
name VARCHAR2(10 CHAR),
author VARCHAR2(10 CHAR));



-- (2) INSERT procedure »ý¼º

CREATE OR REPLACE PROCEDURE sp_books_insert(
p_name IN books.name%TYPE,
p_author IN books.author%TYPE)
IS
BEGIN
    IF LENGTH(p_name) <= 1
    THEN
        dbms_output.put_line('µµ¼­¸íÀº ÃÖ¼Ò µÎ ±ÛÀÚ ÀÌ»óÀÌ µÇ¾î¾ß ÇÕ´Ï´Ù.');
    ELSE
        INSERT INTO books(name, author)
        VALUES (p_name, p_author);
    END IF;
END;
/

DESC sp_books_insert

EXEC sp_books_insert('ÀÌ°ÍÀÌ ÀÚ¹Ù´Ù', '½Å¿ë±Ç');
EXEC sp_books_insert('SQL Yellow', '¹æÇü¿í');
EXEC sp_books_insert('ÆR', 'ÀÌÁöÀº');

BEGIN
    sp_books_insert('¸®´õ½Ê', 'È÷µùÅ©');
END;
/

SELECT * FROM books;



-- (3) NAMEÀ» RETURNÇÏ´Â ÇÔ¼ö

CREATE OR REPLACE FUNCTION sf_books_get_name(p_no books.no%type)
    RETURN books.name%type
IS
    v_name books.name%type;
BEGIN
    SELECT name INTO v_name
    FROM books
    WHERE no = p_no;
    
    RETURN v_name;
END;
/

EXEC dbms_output.put_line(sf_books_get_name(1))


declare
    v_name books.name%type;
begin
    v_name := sf_books_get_name(1);
    dbms_output.put_line(v_name);
end;
/



-- (4) AUTHOR¸¦ RETURNÇÏ´Â ÇÔ¼ö

CREATE OR REPLACE FUNCTION sf_books_get_author(p_no books.no%type)
    RETURN books.author%type
IS
    v_author books.author%type;
BEGIN
    SELECT author INTO v_author
    FROM books
    WHERE no = p_no;
    
    RETURN v_author;
END;
/

EXEC dbms_output.put_line(sf_books_get_author(2))

declare
    v_author books.author%type;
begin
    v_author := sf_books_get_author(2);
    dbms_output.put_line(v_author);
end;
  /
  
  
  
-- (5) ÆÐÅ°Áö »ý¼º ¹× wrapping

EDIT pack_books.SQL

CREATE OR REPLACE PACKAGE pack_books
IS
    PROCEDURE sp_books_insert(
        p_name IN books.NAME%TYPE,
        p_author IN books.author%TYPE);
    
    FUNCTION sf_books_get_name(p_no books.NO%TYPE) 
        RETURN books.NAME%TYPE;
    
    FUNCTION sf_books_get_author(p_no books.NO%TYPE) 
        RETURN books.author%TYPE;

END;
/



edit pack_books_body.sql

create or replace package body pack_books
is

    procedure sp_books_insert(
        p_name in books.name%type,
        p_author in books.author%type)
        is
        begin
          if length(p_name) <= 1 then
            dbms_output.put_line('µµ¼­¸íÀº ÃÖ¼Ò µÎ ±ÛÀÚÀÌ»óÀÌ µÇ¾î¾ß ÇÕ´Ï´Ù ^^');
          else
            insert into books(name, author)
            values (p_name, p_author);
          end if;
    end;

    function sf_books_get_name(p_no books.no%type) 
      return books.name%type
    is
      v_name books.name%type;
    begin
      select name into v_name
      from books
      where no = p_no;

      return v_name;
    end;

    function sf_books_get_author(p_no books.no%type) 
      return books.author%type
    is
      v_author books.author%type;
    begin
      select author into v_author
      from books
      where no = p_no;

      return v_author;
    end;

  end;
/


desc pack_books

exec pack_books.sp_books_insert('Â¯', 'Á¦¿ÍÇÇ')
exec pack_books.sp_books_insert('ºÎµ¿»ê ÅõÀÚ', '±èµ¿»ê')
exec pack_books.sp_books_insert('ÆÄÀÌ½ã', '¹ÚÀÀ¿ë')

select * from books;

exec dbms_output.put_line(pack_books.sf_books_get_name(1))
exec dbms_output.put_line(pack_books.sf_books_get_author(2))


-- (6) trigger »ý¼º

DROP TABLE t1 PURGE;
DROP TABLE t1_audit PURGE;

CREATE TABLE t1
AS
SELECT * FROM emp;

CREATE TABLE t1_audit(
    no number generated as identity,
    userno varchar2(10),
    workdate timestamp,
    empno number,
    old_sal number,
    new_sal number);

CREATE OR REPLACE TRIGGER secure_t1 /* DML Æ®¸®°Å: ROW Æ®¸®°Å */
BEFORE INSERT OR UPDATE OF sal ON t1
FOR EACH ROW
BEGIN
    INSERT INTO t1_audit(userno, workdate, empno, old_sal, new_sal)
    VALUES(user, systimestamp, :old.empno, :old.sal, :new.sal);
END;
/

UPDATE t1
SET sal = sal * 1.1
WHERE deptno = 10;

select * from t1_audit;
