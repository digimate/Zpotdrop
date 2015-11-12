package com.zpotdrop.utils;

import android.content.Context;
import android.os.AsyncTask;
import android.view.View;

import com.zpotdrop.view.CircleProgressBar;

/**
 * @author phuc.tran
 *         An extended class of {@link android.os.AsyncTask}.
 *         This class is used to show a {@link com.zpotdrop.view.CircleProgressBar} when the app is doing long task in the background.
 */
public class SmartTaskUtilsWithProgressBar extends AsyncTask<Void, Void, Void> {

    private Context context;
    private CircleProgressBar progressBar;

    /**
     * This constructor is used when we don't want to show a progress bar for long time task.
     *
     * @param context The context (activity) where this async task is being used.
     */
    public SmartTaskUtilsWithProgressBar(Context context) {
        this.context = context;
    }

    /**
     * This constructor is used when we want to show a progress bar for long time task.
     *
     * @param context     The context (activity) where this async task is being used.
     * @param progressBar The progress bar will be shown.
     */
    public SmartTaskUtilsWithProgressBar(Context context, CircleProgressBar progressBar) {
        this.context = context;
        this.progressBar = progressBar;
    }

    /**
     * This method is called before long time task starts
     */
    protected void onPreExecute() {
        super.onPreExecute();
        if (progressBar != null) {
            progressBar.setVisibility(View.GONE);
        }
    }

    @Override
    protected Void doInBackground(Void... params) {
        return null;
    }

    /**
     * This method is called after long time task starts
     */
    protected void onPostExecute(Void result) {
        super.onPostExecute(result);
        if (progressBar != null && progressBar.isShown()) {
            progressBar.setVisibility(View.GONE);
        }
    }
}
