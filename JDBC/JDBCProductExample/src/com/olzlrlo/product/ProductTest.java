// 동적 쿼리를 활용해 여러 조건으로 조회
package com.olzlrlo.product;

import java.util.ArrayList;

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

commit;
 */

public class ProductTest {
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        String _name = "신발";
        String _color = "Black";

        ProductVO vo = new ProductVO(_name, _color);
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
