package com.olzlrlo.product;

import lombok.Getter;
import lombok.Setter;

public class ProductVO {

    @Getter
    @Setter
    private String code;

    @Getter
    @Setter
    private String name;

    @Getter
    @Setter
    private String color;

    @Getter
    @Setter
    private int qty;

    public ProductVO() {}

    public ProductVO(String name, int qty) {
        this.name = name;
        this.qty = qty;
    }

    public ProductVO(String name, String color) {
        this.name = name;
        this.color = color;
    }
}
