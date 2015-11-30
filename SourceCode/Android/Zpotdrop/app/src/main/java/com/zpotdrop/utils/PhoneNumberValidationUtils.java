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
public class PhoneNumberValidationUtils {

    /**
     * Validate a phone number
     *
     * @param context
     * @param phoneNumber
     * @param errorMessage
     * @return True if the phone number is valid
     */
    public static boolean isValidPhoneNumber(Context context, String phoneNumber, String errorMessage) {
        if (!Patterns.PHONE.matcher(phoneNumber).matches()) {
            Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show();
            return false;
        }
        return true;
    }
}
