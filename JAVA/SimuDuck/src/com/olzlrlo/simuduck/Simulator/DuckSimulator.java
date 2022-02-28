package com.olzlrlo.simuduck.Simulator;

import com.olzlrlo.simuduck.Duck.Duck;
import com.olzlrlo.simuduck.Duck.MallardDuck;
import com.olzlrlo.simuduck.Duck.RubberDuck;

public class DuckSimulator {

    public static void main(String[] args) {
        Duck mallard = new MallardDuck();
        mallard.display();
        mallard.performQuack();
        mallard.performFly();

        System.out.println();

        Duck rubberDuck = new RubberDuck();
        rubberDuck.display();
        rubberDuck.performQuack();
        rubberDuck.performFly();


    }
}
