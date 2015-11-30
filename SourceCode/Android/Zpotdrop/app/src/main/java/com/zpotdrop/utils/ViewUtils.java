/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

/**
 * View adjustment and validation
 *
 * @author Tran Huy Phuc
 */
public class ViewUtils {

    /**
     * Change the dimensions of view
     *
     * @param view   The view that will be changed
     * @param width  New width
     * @param height New height
     */
    public static void changeViewDimensions(View view, int width, int height) {
        view.getLayoutParams().width = width;
        view.getLayoutParams().height = height;
    }

    /**
     * Validate an edit text. If it's empty, show a message
     *
     * @param context  The context where edit text is being used
     * @param editText The validated edit text
     * @param message  The message that will be shown if edit text is empty
     * @return True if there is at least 1 character in edit text
     */
    public static boolean isValidEditText(Context context, EditText editText, String message) {
        String text = editText.getText().toString();
        if (!TextUtils.isEmpty(text)) {
            return true;
        }
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
        return false;
    }

    /**
     * Validate if there is a valid item is selected in spinner
     *
     * @param context The context where spinner
     * @param spinner The spinner that will be invalidated
     * @param message The message that will be shown if there's not valid item is selected
     * @return True if there is a valid item is selected
     */
    public static boolean validateSpinner(Context context, Spinner spinner, String message) {
        if (spinner.getSelectedItemPosition() > 0) {
            return true;
        }
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
        return false;
    }

    /**
     * Validate 2 password fields
     *
     * @param context
     * @param edtPassword
     * @param edtPasswordAgain
     * @param errorMessage
     * @return True if 2 passwords match
     */
    public static boolean isPasswordsMatch(Context context, EditText edtPassword, EditText edtPasswordAgain, String errorMessage) {
        String password = edtPassword.getText().toString();
        String passwordAgain = edtPasswordAgain.getText().toString();

        if (!password.equals(passwordAgain)) {
            Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show();
            return false;
        }

        return true;
    }
}
