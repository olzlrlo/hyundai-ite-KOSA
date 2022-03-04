package com.olzlrlo.callablestatement;

import com.olzlrlo.jdbctest.WithDriverManager;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class BatchInsertT1 {

    public static void main(String[] args) {

        String runSP = "{ call sp_insert_t1(?, ?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, "EMMA");
            callableStatement.setDouble(2, 1700);
            callableStatement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            callableStatement.addBatch();

            callableStatement.setString(1, "OLIVIA");
            callableStatement.setDouble(2, 4200);
            callableStatement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            callableStatement.addBatch();

            callableStatement.setString(1, "LUCAS");
            callableStatement.setDouble(2, 3300);
            callableStatement.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            callableStatement.addBatch();

            callableStatement.executeBatch();

            System.out.println("성공");

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
    }

}
