// executeBatch()로 입력
package com.olzlrlo.callablestatement;

import com.olzlrlo.DBConnection.WithDriverManager;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class BatchInsertProduct {

    public static void main(String[] args) {

        String runSP = "{ call sp_insert_product(?, ?, ?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, "006");
            callableStatement.setString(2, "상의");
            callableStatement.setString(3, "Pink");
            callableStatement.setInt(4, 123);
            callableStatement.addBatch();

            callableStatement.setString(1, "007");
            callableStatement.setString(2, "하의");
            callableStatement.setString(3, "Green");
            callableStatement.setInt(4, 321);
            callableStatement.addBatch();

            callableStatement.executeBatch();

            System.out.println("실행 성공");

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
    }
}
