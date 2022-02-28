package com.olzlrlo.simucar.Car;

import com.olzlrlo.simucar.HonkBehavior.HonkSoftly;
import com.olzlrlo.simucar.DriveBehavior.Stop;

public class Sonata extends Car{

    public Sonata(){
        driveBehavior = new Stop();
        honkBehavior = new HonkSoftly();
    }

    @Override
    public void display() {
        System.out.println("이 차는 Sonata.");
    }

}
