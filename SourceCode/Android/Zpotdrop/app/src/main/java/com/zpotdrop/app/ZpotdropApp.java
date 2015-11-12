package com.zpotdrop.app;

import android.app.Application;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseException;
import com.parse.ParseFacebookUtils;
import com.parse.ParseInstallation;
import com.parse.ParsePush;
import com.parse.ParseUser;
import com.parse.SaveCallback;
import com.zpotdrop.utils.SmartLog;

/**
 * @author phuc.tran
 */
public class ZpotdropApp extends Application {
    private static final String APPLICATION_ID = "ppZUHCYYoJNe1V6ZpAdJfOzJ6vL6mWKKll3V8MM4";
    private static final String CLIENT_KEY = "sBpKO7QEP3jLS73hSoMAB8NyObATl7vlo4e0qLfC";

    @Override
    public void onCreate() {
        super.onCreate();

        initParse();
    }


    private void initParse() {
        //ParseObject.registerSubclass(User.class);
        //ParseObject.registerSubclass(Comment.class);


        // Enable Local Datastore
        Parse.enableLocalDatastore(this);

        Parse.initialize(this, APPLICATION_ID, CLIENT_KEY);
        ParseFacebookUtils.initialize(getApplicationContext());

        ParsePush.subscribeInBackground("global", new SaveCallback() {
            @Override
            public void done(ParseException e) {
                if (e == null) {
                    SmartLog.error(ZpotdropApp.class, "successfully subscribed to the broadcast channel.");
                } else {
                    SmartLog.error(ZpotdropApp.class, e.getMessage());
                }
            }
        });

        ParseACL defaultACL = new ParseACL();
        defaultACL.setPublicReadAccess(true);
        defaultACL.setPublicWriteAccess(true);
        ParseACL.setDefaultACL(defaultACL, true);

        ParseInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {
            @Override
            public void done(ParseException e) {
                if (e == null) {
                    SmartLog.error(ZpotdropApp.class, "installed");
                } else {
                    SmartLog.error(ZpotdropApp.class, e.getMessage());
                }
            }
        });

        ParseUser.enableRevocableSessionInBackground();
    }

}
