/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.util.Patterns;
import android.widget.Toast;

/**
 * @author phuc.tran
 */
public class EmailValidationUtils {

    /**
     * Validate an email
     *
     * @param context
     * @param email        The email that will be validate
     * @param errorMessage The message that will be shown if the email is invalid
     * @return True if the email is valid
     */
    public static boolean isValidEmail(Context context, String email, String errorMessage) {
        if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show();
            return false;
        }
        return true;
    }
}
