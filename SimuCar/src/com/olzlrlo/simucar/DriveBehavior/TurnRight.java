package com.olzlrlo.simucar.DriveBehavior;

public class TurnRight implements DriveBehavior{
    @Override
    public void drive() {
        System.out.println("우회전~");
    }
}
