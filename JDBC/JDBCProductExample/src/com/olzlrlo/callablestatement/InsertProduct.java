// executeUpdate()로 단일행 입력
package com.olzlrlo.callablestatement;

import com.olzlrlo.DBConnection.WithDriverManager;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

/*
drop table product cascade constraints purge;

create table product(
    prod_code  varchar2(10) primary key,
    prod_name  varchar2(30),
    prod_color varchar2(20),
    prod_qty   number(5)
);

insert into product values('001', '상의', 'White', 333);
insert into product values('002', '하의', 'Blue', 222);
insert into product values('003', '신발', 'Black', 111);
insert into product values('004', '가방', 'Red', 444);

create or replace procedure sp_insert_product
(
    p_code in product.prod_code%type,
    p_name in product.prod_name%type,
    p_color in product.prod_color%type,
    p_qty in product.prod_qty%type
)
is
begin
    insert into product(prod_code, prod_name, prod_color, prod_qty)
    values(p_code, p_name, p_color, p_qty);
end;
/
*/

public class InsertProduct {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("제품 번호 입력: ");
        String code = sc.next();

        System.out.print("제품 이름 입력: ");
        String name = sc.next();

        System.out.print("제품 색상 입력: ");
        String color = sc.next();

        System.out.print("제품 수량 입력: ");
        Integer qty = sc.nextInt();

        String runSP = "{ call sp_insert_product(?, ?, ?, ?) }";

        try {
            Connection conn = WithDriverManager.getConnection();
            CallableStatement callableStatement = conn.prepareCall(runSP);

            callableStatement.setString(1, code);
            callableStatement.setString(2, name);
            callableStatement.setString(3, color);
            callableStatement.setInt(4, qty);
            callableStatement.executeUpdate();

            System.out.println("실행 성공");
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
