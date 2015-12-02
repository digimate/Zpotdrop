/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.api;

import android.content.Context;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zpotdrop.model.User;
import com.zpotdrop.utils.SmartLog;
import com.zpotdrop.utils.SmartTaskUtilsWithProgressDialog;

import org.json.JSONObject;

/**
 * @author phuc.tran
 */
public class LoginTask extends SmartTaskUtilsWithProgressDialog {

    SmartRestClient restClient;
    private LoginListener registerListener;
    private boolean isError = true;
    private String errorMessage;

    public LoginTask(Context context, String message, boolean isShowProgressDialog) {
        super(context, message, isShowProgressDialog);
        restClient = new SmartRestClient(ApiConst.URL_LOGIN);
    }

    /**
     * Add parameters
     *
     * @param grantType
     * @param clientId
     * @param clientSecret
     * @param username
     * @param password
     * @param deviceId
     * @param deviceType
     * @param latitude
     * @param longitude
     */
    public void addParams(String grantType, String clientId, String clientSecret,
                          String username, String password, String deviceId,
                          String deviceType, String latitude, String longitude) {
        restClient.addParam(ApiConst.GRANT_TYPE, grantType);
        restClient.addParam(ApiConst.CLIENT_ID, clientId);
        restClient.addParam(ApiConst.CLIENT_SECRET, clientSecret);
        restClient.addParam(ApiConst.USERNAME, username);
        restClient.addParam(ApiConst.PASSWORD, password);
        restClient.addParam(ApiConst.DEVICE_ID, deviceId);
        restClient.addParam(ApiConst.DEVICE_TYPE, deviceType);
        restClient.addParam(ApiConst.LATITUDE, latitude);
        restClient.addParam(ApiConst.LONGITUDE, longitude);
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

                // Login success
                if (apiResponse != null && apiResponse.code == ApiConst.RESPONSE_CODE_SUCCESS) {
                    isError = false;

                    /**
                     * Parse user info
                     */
                    JSONObject responseObject = new JSONObject(response);
                    if (responseObject != null) {
                        String data = responseObject.getString(ApiConst.DATA);
                        User.currentUser = gson.fromJson(data, User.class);
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
            if (registerListener != null) {
                registerListener.onFailed(errorMessage);
            }
        } else {
            if (registerListener != null) {
                registerListener.onSuccess();
            }
        }
    }

    public void setRegisterListener(LoginListener registerListener) {
        this.registerListener = registerListener;
    }

    /**
     * Interface for sign up result
     */
    public interface LoginListener {
        void onSuccess();

        void onFailed(String errorMessage);
    }
}
