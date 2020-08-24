package com.dartnative.dart_native_example;

import android.util.Log;

public class ConstructorTest {
    private static final String TAG = "ConstructorTest";

    public ConstructorTest() {
        this("", 0);
    }

    public ConstructorTest(String s, int i) {
        this(s, i, (byte)0, false);
    }

    public ConstructorTest(String s, int i, byte b, boolean bool) {
        Log.d(TAG, "constructor " + s + " " + i + " " + b + " " + bool);
    }
}
