/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.graphics.Point;
import android.location.Location;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;
import android.view.Display;
import android.view.WindowManager;

public class DeviceManager {

    public static final String TAG = "DeviceManager";
    public static final String ANDROID = "Android";

    public static String getDeviceId(Context context) {
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String deviceId = telephonyManager.getDeviceId();
        SmartLog.error(DeviceManager.class, deviceId);
        return deviceId;
    }

    public static String getDeviceName(Context context) {
        String deviceName = DeviceManager.ANDROID + "-" + android.os.Build.MANUFACTURER + "-" + android.os.Build.MODEL;
        SmartLog.error(DeviceManager.class, deviceName);
        return deviceName;
    }

    @SuppressWarnings("deprecation")
    public static int getScreenWidth(Context context) {
        int width;
        if (android.os.Build.VERSION.SDK_INT >= 13) {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            Point size = new Point();
            display.getSize(size);
            width = size.x;
        } else {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            width = display.getWidth();  // deprecated
        }
        return width;
    }

    @SuppressWarnings("deprecation")
    public static int getScreenHeight(Context context) {
        int height;
        if (android.os.Build.VERSION.SDK_INT >= 13) {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            Point size = new Point();
            display.getSize(size);
            height = size.y;
        } else {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            height = display.getHeight();  // deprecated
        }
        return height;
    }

    /**
     * Get primary email on phone
     *
     * @return The primary email on the phone
     */
//    public static String getEmail(Context context) {
//        Pattern emailPattern = Patterns.EMAIL_ADDRESS;
//        Account[] accounts = AccountManager.get(context).getAccounts();
//        for (Account account : accounts) {
//            if (emailPattern.matcher(account.name).matches()) {
//                String possibleEmail = account.name;
//                if (possibleEmail.length() > 0) {
//                    return possibleEmail;
//                }
//            }
//        }
//        return null;
//    }

    /**
     * Get phone number if possible
     *
     * @param context The context where we want to get phone number
     * @return The phone number
     */
    public static String getPhoneNumber(Context context) {
        TelephonyManager tMgr = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String phoneNumber = tMgr.getLine1Number();
        SmartLog.error(DeviceManager.class, phoneNumber);
        return phoneNumber;
    }

    public static Location getPhoneLocation() {
        Location location = null;
        return location;
    }

    /**
     * Check if the device is connected to internet
     *
     * @param context
     * @return
     */
    public static boolean isConnectedToInternet(Context context) {
        ConnectivityManager cm =
                (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        boolean isConnected = activeNetwork != null &&
                activeNetwork.isConnectedOrConnecting();
        return isConnected;
    }
}
