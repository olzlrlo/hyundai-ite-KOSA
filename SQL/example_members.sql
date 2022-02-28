-- (1) 테이블 생성

DROP TABLE members PURGE;

CREATE TABLE members(
no number(10) generated as identity,
name varchar2(10 char),
mbti varchar2(4 char));



-- (2) INSERT procedure 생성

CREATE OR REPLACE PROCEDURE sp_members_insert(
p_name IN members.name%TYPE,
p_mbti IN members.mbti%TYPE)
IS
BEGIN
    IF LENGTH(p_mbti) != 4
    THEN
        dbms_output.put_line('MBTI는 네 글자입니다.');
    ELSE
        INSERT INTO members(name, mbti)
        VALUES (p_name, p_mbti);
    END IF;
END;
/

DESC sp_members_insert

EXEC sp_members_insert('이지은', 'ESFJ');
EXEC sp_members_insert('김서령', 'INFP');
EXEC sp_members_insert('이윤지', 'ISFP');

BEGIN
    sp_books_insert('안녕', 'XXX');
END;
/

SELECT * FROM members;



-- (3) NAME을 RETURN하는 함수

CREATE OR REPLACE FUNCTION sf_members_get_name(p_no members.no%type)
    RETURN members.name%type
IS
    v_name members.name%type;
BEGIN
    SELECT name INTO v_name
    FROM members
    WHERE no = p_no;
    
    RETURN v_name;
END;
/

EXEC dbms_output.put_line(sf_members_get_name(1))


declare
    v_name members.name%type;
begin
    v_name := sf_members_get_name(2);
    dbms_output.put_line(v_name);
end;
/



-- (4) MBTI를 RETURN하는 함수

CREATE OR REPLACE FUNCTION sf_members_get_mbti(p_no members.no%type)
    RETURN members.mbti%type
IS
    v_mbti members.mbti%type;
BEGIN
    SELECT mbti INTO v_mbti
    FROM members
    WHERE no = p_no;
    
    RETURN v_mbti;
END;
/

EXEC dbms_output.put_line(sf_members_get_mbti(1))

declare
    v_mbti members.mbti%type;
begin
    v_mbti := sf_members_get_mbti(2);
    dbms_output.put_line(v_mbti);
end;
/



-- (5) 패키지 생성 및 wrapping

EDIT pack_members.SQL

CREATE OR REPLACE PACKAGE pack_members
IS
    PROCEDURE sp_members_insert(
        p_name IN members.NAME%TYPE,
        p_mbti IN members.mbti%TYPE);
    
    FUNCTION sf_members_get_name(p_no members.NO%TYPE) 
        RETURN members.NAME%TYPE;
    
    FUNCTION sf_members_get_mbti(p_no members.NO%TYPE) 
        RETURN members.mbti%TYPE;

END;
/



edit pack_members_body.sql

create or replace package body pack_members
is

    PROCEDURE sp_members_insert(
p_name IN members.name%TYPE,
p_mbti IN members.mbti%TYPE)
IS
BEGIN
    IF LENGTH(p_mbti) != 4
    THEN
        dbms_output.put_line('MBTI는 네 글자입니다.');
    ELSE
        INSERT INTO members(name, mbti)
        VALUES (p_name, p_mbti);
    END IF;
END;

    FUNCTION sf_members_get_name(p_no members.no%type)
    RETURN members.name%type
IS
    v_name members.name%type;
BEGIN
    SELECT name INTO v_name
    FROM members
    WHERE no = p_no;
    
    RETURN v_name;
END;

    FUNCTION sf_members_get_mbti(p_no members.no%type)
    RETURN members.mbti%type
IS
    v_mbti members.mbti%type;
BEGIN
    SELECT mbti INTO v_mbti
    FROM members
    WHERE no = p_no;
    
    RETURN v_mbti;
END;

  end;
/



desc pack_members;

exec pack_members.sp_members_insert('서정아', 'ESFJ')
exec pack_members.sp_members_insert('이창희', 'INFJ')
exec pack_members.sp_members_insert('이지수', 'ISFJ')

select * from members;

exec dbms_output.put_line(pack_members.sf_members_get_name(1))
exec dbms_output.put_line(pack_members.sf_members_get_mbti(2))



-- (6) trigger 생성

DROP TABLE t1 PURGE;
DROP TABLE t1_audit PURGE;

CREATE TABLE t1
AS
SELECT * FROM members;

CREATE TABLE t1_audit(
    e_no number generated as identity,
    userno varchar2(10),
    workdate timestamp,
    name varchar2(10 char),
    old_mbti varchar2(4 char),
    new_mbti varchar2(4 char));

DROP TRIGGER secure_t1;
select * from t1;

CREATE OR REPLACE TRIGGER secure_t1 /* DML 트리거: ROW 트리거 */
BEFORE INSERT OR UPDATE OF mbti ON t1
FOR EACH ROW
BEGIN
    INSERT INTO t1_audit(userno, workdate, name, old_mbti, new_mbti)
    VALUES(user, systimestamp, :old.name, :old.mbti, :new.mbti);
END;
/

UPDATE t1
SET mbti = 'INFJ'
WHERE name = '김서령';

select * from t1_audit;



