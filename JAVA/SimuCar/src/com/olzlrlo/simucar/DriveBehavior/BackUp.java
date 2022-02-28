package com.olzlrlo.simucar.DriveBehavior;

public class BackUp implements DriveBehavior{
    @Override
    public void drive() {
        System.out.println("후진!");
    }
}
