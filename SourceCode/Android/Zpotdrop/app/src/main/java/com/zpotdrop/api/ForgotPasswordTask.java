/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.api;

import android.content.Context;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zpotdrop.utils.SmartLog;
import com.zpotdrop.utils.SmartTaskUtilsWithProgressDialog;

import org.json.JSONObject;

/**
 * @author phuc.tran
 */
public class ForgotPasswordTask extends SmartTaskUtilsWithProgressDialog {

    SmartRestClient restClient;
    private ForgotPasswordListener forgotPasswordListener;
    private boolean isError = true;
    private String errorMessage;
    private String successMessage;

    public ForgotPasswordTask(Context context, String message, boolean isShowProgressDialog) {
        super(context, message, isShowProgressDialog);
        restClient = new SmartRestClient(ApiConst.URL_REMIND);
    }

    /**
     * Add parameters
     *
     * @param grantType
     * @param clientId
     * @param clientSecret
     * @param email
     */
    public void addParams(String grantType, String clientId, String clientSecret,
                          String email) {
        restClient.addParam(ApiConst.GRANT_TYPE, grantType);
        restClient.addParam(ApiConst.CLIENT_ID, clientId);
        restClient.addParam(ApiConst.CLIENT_SECRET, clientSecret);
        restClient.addParam(ApiConst.EMAIL, email);
    }

    @Override
    protected Void doInBackground(Void... params) {
        try {
            restClient.execute(SmartRestClient.RequestMethod.POST, context);
            String response = restClient.getResponse();

            if (!TextUtils.isEmpty(response)) {
                SmartLog.error(LoginTask.class, response);
                /**
                 * Get response json
                 */
                GsonBuilder builder = new GsonBuilder();
                Gson gson = builder.create();
                ApiResponse apiResponse = gson.fromJson(response, ApiResponse.class);

                // Request success
                if (apiResponse != null && apiResponse.code == ApiConst.RESPONSE_CODE_SUCCESS) {
                    isError = false;

                    /**
                     * Parse response info
                     */
                    JSONObject responseObject = new JSONObject(response);
                    if (responseObject != null) {
                        String data = responseObject.getString(ApiConst.DATA);
                        SmartLog.error(ForgotPasswordTask.class, data);
                        successMessage = data;
                    }
                } else {
                    isError = true;
                    if (apiResponse != null) {
                        errorMessage = apiResponse.message;
                    }
                }
            } else {
                SmartLog.error(LoginTask.class, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            isError = true;
            errorMessage = e.getMessage();
        }

        return super.doInBackground(params);
    }

    @Override
    protected void onPostExecute(Void result) {
        super.onPostExecute(result);

        if (isError) {
            if (forgotPasswordListener != null) {
                forgotPasswordListener.onFailed(errorMessage);
            }
        } else {
            if (forgotPasswordListener != null) {
                forgotPasswordListener.onSuccess(successMessage);
            }
        }
    }

    public void setForgotPasswordListener(ForgotPasswordListener listener) {
        this.forgotPasswordListener = listener;
    }

    /**
     * Interface for sign up result
     */
    public interface ForgotPasswordListener {
        void onSuccess(String message);

        void onFailed(String errorMessage);
    }
}
