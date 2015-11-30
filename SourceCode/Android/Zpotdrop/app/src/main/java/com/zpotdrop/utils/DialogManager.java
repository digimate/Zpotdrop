/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;

import com.afollestad.materialdialogs.MaterialDialog;
import com.zpotdrop.R;

/**
 * @author phuc.tran
 */
public class DialogManager {

    /**
     * Show an dialog when there is an error
     *
     * @param context
     * @param title
     * @param errorMessage
     */
    public static void showErrorDialog(Context context, String title, String errorMessage) {
        MaterialDialog.Builder builder =
                new MaterialDialog.Builder(context)
                        .title(title)
                        .content(errorMessage)
                        .positiveText(context.getResources().getString(R.string.close));
        MaterialDialog dialog = builder.build();
        dialog.show();
    }
}
