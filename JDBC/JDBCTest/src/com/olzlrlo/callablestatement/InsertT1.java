package com.olzlrlo.callablestatement;

/*
drop table t1 cascade constraints purge;

create table t1
(empno number generated as identity,
 ename varchar2(10),
 sal number(7, 2),
 hiredate date);

insert into t1(ename, sal, hiredate)
select ename, sal, hiredate from emp;

create or replace procedure sp_insert_t1
(p_ename in t1.ename%type,
 p_sal in t1.sal%type,
 p_hiredate in t1.hiredate%type)
is
begin
    insert into t1(ename, sal, hiredate)
    values(p_ename, p_sal, p_hiredate);

commit;
end;
/
*/


import com.olzlrlo.jdbctest.WithDriverManager;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Scanner;

public class InsertT1 {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("이름 입력: ");
        String ename = sc.next();

        System.out.print("급여 입력: ");
        Double sal = sc.nextDouble();

        String runSP = "{ call sp_insert_t1(?, ?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);
            callableStatement.setString(1, ename);
            callableStatement.setBigDecimal(2, new BigDecimal(sal));
            callableStatement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            callableStatement.executeUpdate();
            System.out.println("성공");
        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            sc.close();
        }
    }

}
