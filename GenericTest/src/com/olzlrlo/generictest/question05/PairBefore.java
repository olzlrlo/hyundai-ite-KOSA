package com.olzlrlo.generictest.question05;

// type 소거 이전 Class

public class PairBefore<K, V> {

    public PairBefore(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public K getKey() { return key; }
    public V getValue() { return value; }

    public void setKey(K key)     { this.key = key; }
    public void setValue(V value) { this.value = value; }

    private K key;
    private V value;
}
