package com.olzlrlo.generictest.question01;

import java.util.Collection;

public final class Algorithm {
    public static<T> int countIf(Collection<T> c, UnaryPredicate<T> p){
        int cnt = 0;
        for (T elem : c)
            if (p.test(elem))
                ++cnt;
        return cnt;
    }
}
