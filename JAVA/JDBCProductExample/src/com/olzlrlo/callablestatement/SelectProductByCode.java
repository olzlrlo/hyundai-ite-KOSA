// executeQuery()로 단일행 조회
package com.olzlrlo.callablestatement;

import com.olzlrlo.DBConnection.WithDriverManager;

import java.sql.*;
import java.util.Scanner;

/*
create or replace procedure sp_select_product_by_code
(
    p_code in product.prod_code%type,
    p_name out product.prod_name%type,
    p_color out product.prod_color%type,
    p_qty out product.prod_qty%type
)
is
begin
    select prod_name, prod_color, prod_qty
    into p_name, p_color, p_qty
    from product
    where to_number(prod_code) = p_code;
end;
/

declare
    v_name product.prod_name%type;
    v_color product.prod_color%type;
    v_qty product.prod_qty%type;
begin
    sp_select_product_by_code(&sv_code, v_name, v_color, v_qty);
    dbms_output.put_line(v_name||' '||v_color||' '||v_qty);
end;
/
 */

public class SelectProductByCode {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("제품 번호 입력: ");
        String code = sc.next();

        String runSP = "{ call sp_select_product_by_code(?, ?, ?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, code);
            callableStatement.registerOutParameter(2, java.sql.Types.VARCHAR);
            callableStatement.registerOutParameter(3, java.sql.Types.VARCHAR);
            callableStatement.registerOutParameter(4, Types.INTEGER);

            try {
                callableStatement.executeQuery();

                String name = callableStatement.getString(2);
                String color = callableStatement.getString(3);
                Integer qty = callableStatement.getInt(4);

                System.out.println();
                System.out.println("제품 이름: " + name);
                System.out.println("제품 색상: " + color);
                System.out.println("제품 수량: " + qty);
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
