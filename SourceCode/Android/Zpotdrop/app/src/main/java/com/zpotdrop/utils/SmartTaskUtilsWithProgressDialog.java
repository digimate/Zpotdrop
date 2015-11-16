/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.os.AsyncTask;

import com.zpotdrop.view.ZProgressHUD;

public class SmartTaskUtilsWithProgressDialog extends AsyncTask<Void, Void, Void> {

    ZProgressHUD progressDialog;// = ZProgressHUD.getInstance(context);
    //private ProgressDialog progressDialog;
    private Context context;
    private String message;
    private boolean isShowProgressDialog = true;

    public SmartTaskUtilsWithProgressDialog(Context context, String message) {
        this.context = context;
        this.setMessage(message);
    }

    public SmartTaskUtilsWithProgressDialog(Context context, String message, boolean isShowProgressDialog) {
        this.context = context;
        this.isShowProgressDialog = isShowProgressDialog;
        this.message = message;
    }

    protected void onPreExecute() {
        super.onPreExecute();
        if (isShowProgressDialog) {
            progressDialog = ZProgressHUD.getInstance(context);
            progressDialog.setSpinnerType(ZProgressHUD.SIMPLE_ROUND_SPINNER);
            progressDialog.setMessage(message);
            progressDialog.show();
        }
    }

    protected void onPostExecute(Void result) {
        super.onPostExecute(result);
        if (progressDialog != null && progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
    }

    protected Void doInBackground(Void... params) {
        return null;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
