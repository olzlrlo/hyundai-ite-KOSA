package com.olzlrlo.simuduck.Duck;

import com.olzlrlo.simuduck.FlyBehavior.FlyWithWings;
import com.olzlrlo.simuduck.QuackBehavior.Quack;

public class MallardDuck extends Duck{
    public MallardDuck(){ // 생성자
        quackBehavior = new Quack();
        flyBehavior = new FlyWithWings();
    }

    @Override
    public void display() {
        System.out.println("나는 청둥오리~");
    }
}
