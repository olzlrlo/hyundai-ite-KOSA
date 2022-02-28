package com.olzlrlo;

public class AnimalTestDrive {

    public static void main(String[] args) {

        Object one = new Tiger();
        Tiger tiger = null;
        if (one instanceof Tiger){
            tiger = (Tiger) one; // cast(형 변환) 필요
        }
        tiger.makeNoise();
        System.out.println(tiger.toString());
    }

}
