package com.olzlrlo;

// 단 하나의 추상메소드가 추가되면, 반드시 추상클래스가 돼야함
public abstract class Animal { // abstract 키워드가 추가되면 new 불가
    String picture;
    String food;
    String hunger;
    String boundaries;
    String locations = "어딘가";

    abstract void makeNoise(); // 상속 받는 클래스들이 override

    void eat(){
        System.out.println("먹습니다.");
    }

    void sleep(){
        System.out.println("잡니다.");
    }

    void roam(){
        System.out.println("돌아다닙니다.");
    }

}
