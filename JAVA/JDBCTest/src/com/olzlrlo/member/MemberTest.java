package com.olzlrlo.member;

/*
drop table member cascade constraints purge;

create table member
(id     varchar2(10) primary key,
name   varchar2(10),
height number(5),
weight number(5),
age    number(5));

insert into member values('001', 'Peter', 175, 67, 24);
insert into member values('002', 'Diana', 188, 78, 31);
insert into member values('003', 'Jennifer', 165, 48, 17);
insert into member values('004', 'Bruce', 177, 78, 23);

commit;
*/

import java.util.ArrayList;

public class MemberTest {

    public static void main(String[] args) {
        MemberDAO dao = new MemberDAO();
        ArrayList<MemberVO> list = dao.list();

        for (int i = 0; i < list.size(); i++) {
            MemberVO data = (MemberVO) list.get(i);
            String id = data.getId();
            String name = data.getName();
            int height = data.getHeight();
            int weight = data.getWeight();
            int age = data.getAge();

            System.out.println("아이디는 " + id + ", 이름은 " + name + ", 키는 " + height + "cm" +
                    ", 몸무게는 " + weight + "kg" + ", 나이는 " + age + "살");
        }
    }

}

