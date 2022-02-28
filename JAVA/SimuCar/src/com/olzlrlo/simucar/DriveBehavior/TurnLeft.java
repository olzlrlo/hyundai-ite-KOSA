package com.olzlrlo.simucar.DriveBehavior;

public class TurnLeft implements DriveBehavior{
    @Override
    public void drive() {
        System.out.println("좌회전~");
    }
}
