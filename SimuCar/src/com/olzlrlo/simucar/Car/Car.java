package com.olzlrlo.simucar.Car;

import com.olzlrlo.simucar.DriveBehavior.DriveBehavior;
import com.olzlrlo.simucar.HonkBehavior.HonkBehavior;

public abstract class Car {
    DriveBehavior driveBehavior;
    HonkBehavior honkBehavior;

    public abstract void display();
    public void performDrive() {driveBehavior.drive();}
    public void performHonk() {honkBehavior.honk();}

    public void setDriveBehavior(DriveBehavior driveBehavior){
        this.driveBehavior = driveBehavior;
    }
}
