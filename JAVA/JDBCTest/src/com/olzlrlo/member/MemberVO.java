package com.olzlrlo.member;

import lombok.Getter;
import lombok.Setter;

public class MemberVO {

    @Getter
    @Setter
    private String id;

    @Getter
    @Setter
    private String name;

    @Getter
    @Setter
    private int height;

    @Getter
    @Setter
    private int weight;

    @Getter
    @Setter
    private int age;

    public MemberVO() {
    }

    public MemberVO(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public MemberVO(String id, String name, int height, int weight, int age) {
        this.id = id;
        this.name = name;
        this.height = height;
        this.weight = weight;
        this.age = age;
    }
}
