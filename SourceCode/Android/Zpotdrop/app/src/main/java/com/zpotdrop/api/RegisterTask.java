/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.api;

import android.content.Context;
import android.text.TextUtils;

import com.zpotdrop.utils.SmartLog;
import com.zpotdrop.utils.SmartTaskUtilsWithProgressDialog;

/**
 * @author phuc.tran
 */
public class RegisterTask extends SmartTaskUtilsWithProgressDialog {

    SmartRestClient restClient;
    private RegisterListener registerListener;

    public RegisterTask(Context context, String message, boolean isShowProgressDialog) {
        super(context, message, isShowProgressDialog);
        restClient = new SmartRestClient(ApiConst.URL_REGISTER);
    }

    /**
     * Add parameters
     *
     * @param grantType
     * @param clientId
     * @param clientSecret
     * @param email
     * @param password
     * @param firstName
     * @param lastName
     * @param birthDay
     * @param phoneNumber
     * @param gender
     * @param deviceId
     * @param deviceType
     * @param latitude
     * @param longitude
     */
    public void addParams(String grantType, String clientId, String clientSecret,
                          String email, String password, String firstName,
                          String lastName, String birthDay, String phoneNumber,
                          String gender, String deviceId, String deviceType,
                          String latitude, String longitude) {
        restClient.addParam(ApiConst.GRANT_TYPE, grantType);
        restClient.addParam(ApiConst.CLIENT_ID, clientId);
        restClient.addParam(ApiConst.CLIENT_SECRET, clientSecret);
        restClient.addParam(ApiConst.EMAIL, email);
        restClient.addParam(ApiConst.PASSWORD, password);
        restClient.addParam(ApiConst.FIRST_NAME, firstName);
        restClient.addParam(ApiConst.LAST_NAME, lastName);
        restClient.addParam(ApiConst.BIRTHDAY, birthDay);
        restClient.addParam(ApiConst.PHONE_NUMBER, phoneNumber);
        restClient.addParam(ApiConst.GENDER, gender);
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
                SmartLog.error(RegisterTask.class, response);
            }
            if (registerListener != null) {
                registerListener.onSuccess();
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (registerListener != null) {
                registerListener.onFailed(e.getMessage());
            }
        }

        return super.doInBackground(params);
    }

    @Override
    protected void onPostExecute(Void result) {
        super.onPostExecute(result);
    }

    public void setRegisterListener(RegisterListener registerListener) {
        this.registerListener = registerListener;
    }

    /**
     * Interface for sign up result
     */
    public interface RegisterListener {
        void onSuccess();

        void onFailed(String errorMessage);
    }
}
