package com.olzlrlo.jdbctest;

// 먼저 olzlrlo user로 접속해서 테이블을 생성
// drop table t1 cascade constraints purge;
// create table t1 as select employee_id, first_name from employees;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCInsertTest {

    public static void main(String args[]) throws SQLException {

        Connection conn = null;
        Statement stmt = null;
        PreparedStatement pstmt = null;

        conn = WithDriverManager.getConnection();
        conn.setAutoCommit(false); // 자동 커밋 기능 OFF

        try {
            pstmt = conn.prepareStatement("insert into t1 (EMPLOYEE_ID, FIRST_NAME) values (?, ?)");
            stmt = conn.createStatement();

            pstmt.setInt(1, 1500);
            pstmt.setString(2, "LESLIE");
            pstmt.execute();
            conn.commit();
            // stmt.executeUpdate("truncate table t1");

            pstmt.setInt(1, 507);
            pstmt.setString(2, "MARSHA");
            pstmt.execute();
            conn.commit();
            // stmt.executeUpdate("truncate table t1");

            System.out.println("입력 성공!");
        } finally {

            if (pstmt != null)
                pstmt.close();
        }

    }

}
