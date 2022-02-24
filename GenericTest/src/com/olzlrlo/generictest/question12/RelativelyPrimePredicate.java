package com.olzlrlo.generictest.question12;

import java.util.Collection;

public class RelativelyPrimePredicate implements UnaryPredicate<Integer>{
    public RelativelyPrimePredicate(Collection<Integer> c) {
        this.c = c;
    }

    @Override
    public boolean test(Integer x) {
        for (Integer i : c)
            if (Algorithm.gcd(x, i) != 1)
                return false;

        return c.size() > 0;
    }

    private Collection<Integer> c;
}
