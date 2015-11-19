/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.app;

import android.app.Application;
import android.graphics.Typeface;

/**
 * @author phuc.tran
 */
public class ZpotdropApp extends Application {
    public static Typeface openSansRegular;
    public static Typeface openSansLight;
    public static Typeface openSansBold;

    public static String DATE_FORMAT = "dd-MM-yyyy";

    @Override
    public void onCreate() {
        super.onCreate();

        createFonts();
    }

    /**
     * Create fonts from assets
     */
    private void createFonts() {
        ZpotdropApp.openSansRegular = Typeface.createFromAsset(getAssets(), "OpenSans-Regular.ttf");
        ZpotdropApp.openSansLight = Typeface.createFromAsset(getAssets(), "OpenSans-Light.ttf");
        ZpotdropApp.openSansBold = Typeface.createFromAsset(getAssets(), "OpenSans-Bold.ttf");
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
    }
}

