package com.olzlrlo.lomboktest;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class ElectricGuitar {
    private String brand;
    private int numOfPickups;
    private boolean rockStarUsesIt;
}

