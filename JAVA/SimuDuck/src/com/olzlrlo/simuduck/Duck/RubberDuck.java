package com.olzlrlo.simuduck.Duck;

import com.olzlrlo.simuduck.FlyBehavior.FlyNoWay;
import com.olzlrlo.simuduck.QuackBehavior.Squeak;

public class RubberDuck extends Duck{

    public RubberDuck(){
        flyBehavior = new FlyNoWay();
        quackBehavior = new Squeak();
    }

    @Override
    public void display() {
        System.out.println("나는 러버덕~");
    }
}
