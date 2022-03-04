package com.olzlrlo.product;

import com.olzlrlo.DBConnection.WithDriverManager;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class ProductDAO {

    private Connection conn = WithDriverManager.getConnection();
    private Statement stmt;
    private ResultSet rs;

    public ArrayList<ProductVO> list(ProductVO vo) {

        String _name = vo.getName();
        String _color = vo.getColor();

        ArrayList<ProductVO> list = new ArrayList<ProductVO>();

        try {
            String query = "select * from product";
            if (_name != null && _color != null) {
                query += " where prod_name='" + _name + "' and prod_color='" + _color + "'";
            } else if (_name != null && _color == null) {
                query += " where prod_name='" + _name + "'";
            } else if (_name == null && _color != null) {
                query += " where prod_color='" + _color + "'";
            }

            System.out.println(query);

            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                String code = rs.getString("prod_code");
                String name = rs.getString("prod_name");
                String color = rs.getString("prod_color");
                int qty = rs.getInt("prod_qty");

                ProductVO data = new ProductVO();

                data.setCode(code);
                data.setName(name);
                data.setColor(color);
                data.setQty(qty);

                list.add(data);
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 제품 정보 갱신
    public void modProduct(ProductVO vo) {
        String _name = null;
        int _qty = 0;

        _name = vo.getName();
        _qty = vo.getQty();

        try {
            String query = "update product ";
            query += "set prod_qty=" + (_qty + 1) ;
            query += " where prod_name='" + _name + "'";

            System.out.println(query);
            stmt = conn.createStatement();
            stmt.executeUpdate(query);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}