package com.olzlrlo.jdbctest;


import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

import oracle.jdbc.pool.OracleDataSource;


public class WithOracleDataSource {

    @SuppressWarnings("unused")
    public static void main(String args[]) throws SQLException {

        OracleDataSource ods = new OracleDataSource();

        /* Thin driver */

        // 1
        ods.setURL("jdbc:oracle:thin:@localhost:1521/ORCLPDB");
        ods.setUser("olzlrlo");
        ods.setPassword("me");
        Connection conn1 = ods.getConnection();

        DatabaseMetaData meta1 = conn1.getMetaData();
        System.out.println("JDBC driver version is " + meta1.getDriverVersion());

        // 2
        ods.setURL("jdbc:oracle:thin:olzlrlo/me@localhost:1521/orclpdb");
        Connection conn2 = ods.getConnection();

        DatabaseMetaData meta2 = conn1.getMetaData();
        System.out.println("JDBC driver version is " + meta2.getDriverVersion());

        /* Oracle Call Interface (OCI) driver */

        // 1
        ods.setURL("jdbc:oracle:oci8:@mydb");
        ods.setUser("olzlrlo");
        ods.setPassword("me");
        Connection conn3 = ods.getConnection();

        DatabaseMetaData meta3 = conn1.getMetaData();
        System.out.println("JDBC driver version is " + meta3.getDriverVersion());

        // 2
        ods.setURL("jdbc:oracle:oci8:olzlrlo/me@mydb");
        Connection conn4 = ods.getConnection();

        DatabaseMetaData meta4 = conn1.getMetaData();
        System.out.println("JDBC driver version is " + meta4.getDriverVersion());

        /* 설정 파일 + 싱글턴 패턴 활용 접속 */
         Connection conn5 = WithDriverManager.getConnection();

        DatabaseMetaData meta5 = conn1.getMetaData();
        System.out.println("JDBC driver version is " + meta5.getDriverVersion());
    }

}
