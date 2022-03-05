// execute()로 여러 행 조회
package com.olzlrlo.callablestatement;

import com.olzlrlo.DBConnection.WithDriverManager;

import oracle.jdbc.OracleTypes;

import java.sql.*;
import java.util.Scanner;

/*
create or replace procedure sp_select_product_by_name_like
(
    p_name in product.prod_name%type,
    p_cursor out sys_refcursor
)
is
begin
    open p_cursor for
        select *
        from product
        where prod_name like upper(p_name)||'%';
end;
/

declare
    v_cursor sys_refcursor;
    product_rec product%rowtype;
begin
    sp_select_product_by_name_like('&sv_name', v_cursor);

    loop
        fetch v_cursor into product_rec;
        exit when v_cursor%notfound;
        dbms_output.put_line('-------------');
        dbms_output.put_line(product_rec.prod_code);
        dbms_output.put_line(product_rec.prod_name);
        dbms_output.put_line(product_rec.prod_color);
        dbms_output.put_line(product_rec.prod_qty);
    end loop;

    close v_cursor;
end;
/
*/

public class SelectProductByNameLike {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("제품 이름: ");
        String name = sc.next();

        String runSP = "{ call sp_select_product_by_name_like(?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, name);
            callableStatement.registerOutParameter(2, OracleTypes.CURSOR);

            try {
                callableStatement.execute();
                ResultSet resultSet = (ResultSet) callableStatement.getObject(2);

                while (resultSet.next()) {
                    String code = resultSet.getString(1);
                    name = resultSet.getString(2);
                    String color = resultSet.getString(3);
                    Integer qty = resultSet.getInt(4);
                    System.out.println("제품 번호: " + code);
                    System.out.println("제품 이름: " + name);
                    System.out.println("제품 색상: " + color);
                    System.out.println("제품 수량: " + qty);
                }

                System.out.println("\n실행 성공");

            } catch (SQLException e) {
                System.out.println("프로시저에서 에러 발생");
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
