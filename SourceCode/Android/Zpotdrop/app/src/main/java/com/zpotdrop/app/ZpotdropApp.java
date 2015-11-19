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

    //    private void initParse() {
//        //ParseObject.registerSubclass(User.class);
//        //ParseObject.registerSubclass(Comment.class);
//
//
//        // Enable Local Datastore
//        Parse.enableLocalDatastore(this);
//
//        Parse.initialize(this, APPLICATION_ID, CLIENT_KEY);
//        ParseFacebookUtils.initialize(getApplicationContext());
//
//        ParsePush.subscribeInBackground("global", new SaveCallback() {
//            @Override
//            public void done(ParseException e) {
//                if (e == null) {
//                    SmartLog.error(ZpotdropApp.class, "successfully subscribed to the broadcast channel.");
//                } else {
//                    SmartLog.error(ZpotdropApp.class, e.getMessage());
//                }
//            }
//        });
//
//        ParseACL defaultACL = new ParseACL();
//        defaultACL.setPublicReadAccess(true);
//        defaultACL.setPublicWriteAccess(true);
//        ParseACL.setDefaultACL(defaultACL, true);
//
//        ParseInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {
//            @Override
//            public void done(ParseException e) {
//                if (e == null) {
//                    SmartLog.error(ZpotdropApp.class, "installed");
//                } else {
//                    SmartLog.error(ZpotdropApp.class, e.getMessage());
//                }
//            }
//        });
//
//        ParseUser.enableRevocableSessionInBackground();
//    }

}

