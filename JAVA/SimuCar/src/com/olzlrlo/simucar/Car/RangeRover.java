package com.olzlrlo.simucar.Car;

import com.olzlrlo.simucar.HonkBehavior.HonkStrongly;
import com.olzlrlo.simucar.DriveBehavior.Stop;

public class RangeRover extends Car{

    public RangeRover(){
        driveBehavior = new Stop();
        honkBehavior = new HonkStrongly();
    }

    @Override
    public void display() {
        System.out.println("이 차는 Range Rover.");
    }

}
