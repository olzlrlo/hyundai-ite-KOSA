package com.olzlrlo.generictest.question12;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

// How do you invoke the following method to find
// the first integer in a list that is relatively prime to a list of specified integers?

public class Test {
    public static void main(String[] args) {
        List<Integer> li = Arrays.asList(1, 3, 6, 7, 8, 15, 22);
        Collection<Integer> c = Arrays.asList(2, 5, 9, 16);
        UnaryPredicate<Integer> p = new RelativelyPrimePredicate(c);

        int i =Algorithm.findFirst(li, 0, li.size(), p);

        if(i != -1){
            System.out.println(li.get(i) + " is relatively prime to ");
            for (Integer k : c)
                System.out.print(k + " ");
            System.out.println();
        }


    }
}
