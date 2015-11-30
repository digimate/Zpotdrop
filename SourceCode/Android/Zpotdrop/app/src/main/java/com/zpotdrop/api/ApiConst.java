/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.api;

/**
 * @author phuc.tran
 *         Define all URLs and parameter keys here
 */
public class ApiConst {
    public static final String BASE_URL = "http://api.zpotdrop.com/api/v1";

    /**
     * RESPONSE CODES
     */
    public static final int RESPONSE_CODE_SUCCESS = 200;
    public static final int RESPONSE_CODE_BAD_REQUEST = 400;

    /**
     * LOGIN
     */
    public static final String URL_LOGIN = BASE_URL + "/oauth/login";
    public static final String GRANT_TYPE = "grant_type";
    public static final String CLIENT_ID = "client_id";
    public static final String CLIENT_SECRET = "client_secret";
    public static final String USERNAME = "username";
    public static final String PASSWORD = "password";
    public static final String DEVICE_ID = "device_id";
    public static final String DEVICE_TYPE = "device_type";
    public static final String DEVICE_TYPE_IOS = "0";
    public static final String DEVICE_TYPE_ANDROID = "1";
    public static final String LATITUDE = "lat";
    public static final String LONGITUDE = "long";
    public static final String PHONE_NUMBER = "phone_number";

    /**
     * REGISTER
     */
    public static final String URL_REGISTER = BASE_URL + "/oauth/register";
    public static final String EMAIL = "email";
    public static final String FIRST_NAME = "first_name";
    public static final String LAST_NAME = "last_name";
    public static final String BIRTHDAY = "birthday";
    public static final String GENDER = "gender";
    public static final int GENDER_MALE = 0;
    public static final int GENDER_FEMALE = 1;
    public static final int GENDER_OTHERS = 2;

    /**
     * LOGOUT
     */
    public static final String URL_LOGOUT = BASE_URL + "/oauth/logout";
    public static final String ACCESS_TOKEN = "access_token";

    /**
     * REMIND
     */
    public static final String URL_REMIND = BASE_URL + "/oauth/password/remind";

    /**
     * CHANGE PASSWORD
     */
    public static final String URL_CHANGE_PASSWORD = BASE_URL + "/oauth/password/change";

    /**
     * POSTS
     */

}
