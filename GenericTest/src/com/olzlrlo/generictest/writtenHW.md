https://docs.oracle.com/javase/tutorial/java/generics/QandE/generics-answers.html

### 2. Will the following class compile? If not, why?
```java
public final class Algorithm {
    public static <T> T max(T x, T y) {
        return x > y ? x : y;
    }
}
```
* 컴파일 오류
* 연산자 >는 오직 primitive numeric 타입에만 적용 가능하기 때문
* 아래와 같이 바꿔야 함


### 4. If the compiler erases all type parameters at compile time, why should you use generics?

* 자바 컴파일러는 컴파일 시 제네릭 코드에 대해 엄격한 타입 검사를 시행하기 때문
* 제네릭은 프로그래밍 유형을 매개 변수로 지원하기 때문
* 제네릭을 사용하면 일반 알고리즘을 구현할 수 있기 때문


### 6. What is the following method converted to after type erasure?
```java
public static <T extends Comparable<T>>
    int findFirstGreaterThan(T[] at, T elem) {
    // ...
}
```
```java
public static int findFirstGreaterThan(Comparable[] at, Comparable elem) {
    // ...
    }
```


### 7. Will the following method compile? If not, why?
```java
public static void print(List<? extends Number> list) {
    for (Number n : list)
        System.out.print(n + " ");
    System.out.println();
}
```
* 컴파일 성공


### 9. Will the following class compile? If not, why?
```java
public class Singleton<T> {

    public static T getInstance() {
        if (instance == null)
            instance = new Singleton<T>();

        return instance;
    }

    private static T instance = null;
}
```
* 컴파일 오류
* type parameter의 static field를 생성할 수 없기 때문


### 10. Will the following code compile? If not, why?
```java
class Shape { /* ... */ }
class Circle extends Shape { /* ... */ }
class Rectangle extends Shape { /* ... */ }

class Node<T> { /* ... */ }
    
Node<Circle> nc = new Node<>();
Node<Shape> ns = nc;
```
* 컴파일 오류
* Node<Circle>은 Node<Shape>의 하위 타입이 아니기 때문


### 11. Will the following code compile? If not, why?
```java
class Node<T> implements Comparable<T> {
    public int compareTo(T obj) { /* ... */ }
    // ...
}

Node<String> node = new Node<>();
Comparable<String> comp = node;
```
* 컴파일 성공