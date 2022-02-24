package com.olzlrlo.simucar.DriveBehavior;

public class Stop implements DriveBehavior{

    @Override
    public void drive() {
        System.out.println("멈춤!!");
    }
}
