/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;

import com.afollestad.materialdialogs.DialogAction;
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

    /**
     * Show a dialog
     *
     * @param context
     * @param title
     * @param message
     * @param shouldCloseActivity If true -> close dialog when clicking on positive button
     */
    public static void showSuccessDialog(final Context context, String title, String message, final boolean shouldCloseActivity) {
        MaterialDialog.Builder builder =
                new MaterialDialog.Builder(context)
                        .title(title)
                        .content(message)
                        .positiveText(context.getResources().getString(R.string.close))
                        .onPositive(new MaterialDialog.SingleButtonCallback() {
                            @Override
                            public void onClick(@NonNull MaterialDialog materialDialog, @NonNull DialogAction dialogAction) {
                                if (shouldCloseActivity) {
                                    ((Activity) context).finish();
                                    ((Activity) context).overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
                                }
                            }
                        });
        MaterialDialog dialog = builder.build();
        dialog.show();
    }
}
