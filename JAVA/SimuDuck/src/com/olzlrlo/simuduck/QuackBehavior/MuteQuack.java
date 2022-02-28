package com.olzlrlo.simuduck.QuackBehavior;

public class MuteQuack implements QuackBehavior{
    @Override
    public void quack() {
        System.out.println("<<Silence>>");
    }
}
