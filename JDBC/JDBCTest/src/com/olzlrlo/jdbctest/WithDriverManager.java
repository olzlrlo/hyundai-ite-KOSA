package com.olzlrlo.jdbctest;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class WithDriverManager {

    private static Connection conn;

    private WithDriverManager() {}

    static {
        Properties properties = new Properties();  // 환경 설정 파일을 읽어올 객체 생성
        Reader reader;
        try {
            reader = new FileReader("lib/oracle.properties");  // 읽어올 파일 지정
            properties.load(reader);  // 설정 파일 load
        } catch (FileNotFoundException e1) {
            System.out.println("예외: 지정한 파일을 찾을 수 없음 :" + e1.getMessage());
            e1.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        String driverName = properties.getProperty("driver");
        String url = properties.getProperty("url");
        String user = properties.getProperty("user");
        String pwd = properties.getProperty("password");

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, user, pwd);
            System.out.println("connection success");
        } catch (ClassNotFoundException e) {
            System.out.println("예외: Driver 로드 실패 :" + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("예외: connection fail :" + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        return conn;
    }
}