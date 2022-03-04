// 제품 정보 갱신
package com.olzlrlo.product;

import java.util.ArrayList;

public class ProductTest2 {

    public static void main(String[] args) {

        ProductDAO dao = new ProductDAO();
        String _name = "신발";
        int _qty = 135;

        ProductVO vo = new ProductVO(_name, _qty);
        dao.modProduct(vo);

        ArrayList<ProductVO> list = dao.list(vo);

        for (int i = 0; i < list.size(); i++) {
            ProductVO data = list.get(i);
            String code = data.getCode();
            String name = data.getName();
            String color = data.getColor();
            int qty = data.getQty();

            System.out.println("제품 번호는 " + code + ", 이름은 " + name
                    + ", 색상은 " + color + ", 수량은 " + qty + "개");
        }
    }

}
