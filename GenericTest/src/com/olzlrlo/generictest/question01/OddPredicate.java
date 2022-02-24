package com.olzlrlo.generictest.question01;

public class OddPredicate implements UnaryPredicate<Integer>{

    @Override
    public boolean test(Integer i) {
        return i % 2 != 0;
    }
}
