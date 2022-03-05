package com.olzlrlo.connectionpool;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

// drop table t1 purge;
// create table t1 as select * from dept;

public class ConnectionPoolMemberTest {
	private static final String driver = "oracle.jdbc.driver.OracleDriver";
	private static final String url = "jdbc:oracle:thin:@localhost:1521/orclpdb";
	private static final String user = "olzlrlo";
	private static final String pwd = "me";
	private static final int initialCons = 5;
	private static final int maxCons = 20;
	private static final boolean block = true;
	private static final long timeout = 10000;

	public static void main(String[] args) {
		Connection conn;
		Statement stmt;
		ResultSet rs;
		ConnectionPool cp;

		try {
			Class.forName(driver);
			System.out.println("Oracle Driver 로딩 성공");

			// Connection Pool 생성
			cp = new ConnectionPool(url, user, pwd, initialCons, maxCons, block, timeout);
			System.out.println("Connection Pool 생성");

			conn = cp.getConnection();

			stmt = conn.createStatement();
			System.out.println("Statement 생성 성공\n");

			String query = "INSERT INTO t1 VALUES (50, 'IT', 'SEOUL')";
			System.out.println(query);
			stmt.executeUpdate(query);

			String query2 = "SELECT * FROM t1";
			System.out.println(query2);
			rs = stmt.executeQuery(query2);
			System.out.println();

			while (rs.next()) {
				System.out.println("부서 번호: " + rs.getInt("deptno"));
				System.out.println("부서 이름: " + rs.getString("dname"));
				System.out.println("근무 지역: " + rs.getString("loc"));
				System.out.println();
			}

			rs.close();
			stmt.close();

			// Connection 닫지 않기
			// conn.close();
			// Connection Pool에게 사용한 Connection을 돌려줌
			cp.releaseConnection(conn);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
