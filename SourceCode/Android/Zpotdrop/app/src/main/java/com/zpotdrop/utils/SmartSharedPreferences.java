/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.zpotdrop.consts.Const;

/**
 * @author phuc.tran
 */
public class SmartSharedPreferences {

    /**
     * Set sent token to server value
     *
     * @param context
     * @param isSent
     */
    public static void setSentTokenToServer(Context context, boolean isSent) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        sharedPreferences.edit().putBoolean(Const.SENT_TOKEN_TO_SERVER, isSent).commit();
    }

    public static boolean getSentTokenToServer(Context context) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        boolean isSent = sharedPreferences.getBoolean(Const.SENT_TOKEN_TO_SERVER, false);
        return isSent;
    }

    /**
     * Get GCM token
     *
     * @param context
     * @return
     */
    public static String getGCMToken(Context context) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        String gcmToken = sharedPreferences.getString(Const.GCM_TOKEN, null);
        return gcmToken;
    }

    /**
     * Save GCM token
     *
     * @param context
     * @param gcmToken
     */
    public static void setGCMToken(Context context, String gcmToken) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        sharedPreferences.edit().putString(Const.GCM_TOKEN, gcmToken).commit();
    }
}
