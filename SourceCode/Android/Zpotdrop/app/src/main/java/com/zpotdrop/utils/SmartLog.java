package com.zpotdrop.utils;

import android.util.Log;

public class SmartLog {
    private static final boolean DEBUG = true;

    public static <T> void error(Class<T> source, String message, Throwable e) {
        if (DEBUG) {
            Log.e(getLogTagFromClass(source), "" + message, e);
        }
    }

    public static <T> void error(Class<T> source, int number, Throwable e) {
        if (DEBUG) {
            Log.e(getLogTagFromClass(source), "" + number, e);
        }
    }

    public static <T> void debug(Class<T> source, String message, Throwable e) {
        if (DEBUG) {
            Log.d(getLogTagFromClass(source), "" + message, e);
        }
    }

    public static <T> void verbose(Class<T> source, String message, Throwable e) {
        if (DEBUG) {
            Log.v(getLogTagFromClass(source), "" + message, e);
        }
    }

    public static <T> void info(Class<T> source, String message, Throwable e) {
        if (DEBUG) {
            Log.i(getLogTagFromClass(source), "" + message, e);
        }
    }

    public static <T> void error(Class<T> source, String message) {
        if (DEBUG) {
            Log.e(getLogTagFromClass(source), "" + message);
        }
    }

    public static <T> void error(Class<T> source, int number) {
        if (DEBUG) {
            Log.e(getLogTagFromClass(source), "" + number);
        }
    }

    public static <T> void debug(Class<T> source, String message) {
        if (DEBUG) {
            Log.d(getLogTagFromClass(source), "" + message);
        }
    }

    public static <T> void verbose(Class<T> source, String message) {
        if (DEBUG) {
            Log.v(getLogTagFromClass(source), "" + message);
        }
    }

    public static <T> void info(Class<T> source, String message) {
        if (DEBUG) {
            Log.i(getLogTagFromClass(source), "" + message);
        }
    }

    public static <T> void warn(Class<T> source, String message, Throwable e) {
        if (DEBUG) {
            Log.w(getLogTagFromClass(source), "" + message, e);
        }
    }

    public static <T> void warn(Class<T> source, String message) {
        if (DEBUG) {
            Log.w(getLogTagFromClass(source), "" + message);
        }
    }

    public static <T> void warn(Class<T> source, Throwable e) {
        if (DEBUG) {
            Log.w(getLogTagFromClass(source), e);
        }
    }

    private static <T> String getLogTagFromClass(Class<T> cls) {
        if (cls != null) {
            return cls.getSimpleName();
        }
        return "???";
    }
}
