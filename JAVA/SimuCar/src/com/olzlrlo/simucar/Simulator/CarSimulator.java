package com.olzlrlo.simucar.Simulator;

import com.olzlrlo.simucar.Car.Car;
import com.olzlrlo.simucar.Car.RangeRover;
import com.olzlrlo.simucar.Car.Sonata;
import com.olzlrlo.simucar.DriveBehavior.TurnLeft;
import com.olzlrlo.simucar.DriveBehavior.TurnRight;

public class CarSimulator {

    public static void main(String[] args) {
        Car c1 = new RangeRover();
        c1.display();
        c1.setDriveBehavior(new TurnLeft());
        c1.performDrive();
        c1.performHonk();

        System.out.println();

        Car c2 = new Sonata();
        c2.display();
        c2.setDriveBehavior(new TurnRight());
        c2.performDrive();
        c2.performHonk();


    }
}
