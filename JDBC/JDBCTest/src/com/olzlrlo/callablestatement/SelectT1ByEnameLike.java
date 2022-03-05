package com.olzlrlo.callablestatement;

/*
create or replace procedure sp_select_t1_by_ename_like
(p_ename in t1.ename%type,
 p_cursor out sys_refcursor)
is
begin
    open p_cursor for
        select *
        from t1
        where ename like upper(p_ename)||'%';
end;
/

set verify off
set serveroutput on

declare
    v_cursor sys_refcursor;
    t1_rec t1%rowtype;
begin
    sp_select_t1_by_ename_like('&sv_ename', v_cursor);

    loop
        fetch v_cursor into t1_rec;
        exit when v_cursor%notfound;
        dbms_output.put_line('-------------');
        dbms_output.put_line(t1_rec.empno);
        dbms_output.put_line(t1_rec.ename);
        dbms_output.put_line(t1_rec.sal);
        dbms_output.put_line(t1_rec.hiredate);
    end loop;

    close v_cursor;
end;
/
 */
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import com.olzlrlo.jdbctest.WithDriverManager;
import oracle.jdbc.OracleTypes;

public class SelectT1ByEnameLike {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("사원 이름: ");
        String ename = sc.next();

        String runSP = "{ call sp_select_t1_by_ename_like(?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, ename);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
            System.out.println();

            try {
                callableStatement.execute();
                ResultSet resultSet = (ResultSet) callableStatement.getObject(2);

                while (resultSet.next()) {
                    int empno = resultSet.getInt(1);
                    ename = resultSet.getString(2);
                    BigDecimal salary = resultSet.getBigDecimal(3);
                    Date createdDate = resultSet.getDate(4);
                    System.out.println("empno: " + empno);
                    System.out.println("name: " + ename);
                    System.out.println("salary: " + salary);
                    System.out.println("createdDate: " + createdDate);
                    System.out.println();
                }

                System.out.println("성공");

            } catch (SQLException e) {
                System.out.println("프로시저에서 에러 발생!");
                // System.err.format("SQL State: %s", e.getSQLState());
                System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            sc.close();
        }
    }

}
