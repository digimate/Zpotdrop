package com.zpotdrop.utils;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;

public class SmartTaskUtilsWithProgressDialog extends AsyncTask<Void, Void, Void> {

    private ProgressDialog progressDialog;
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
            progressDialog = new ProgressDialog(context);
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
