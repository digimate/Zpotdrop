/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.activity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Location;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.zpotdrop.R;
import com.zpotdrop.api.ApiConst;
import com.zpotdrop.api.LoginTask;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.consts.Const;
import com.zpotdrop.model.MyLocation;
import com.zpotdrop.service.RegistrationIntentService;
import com.zpotdrop.utils.DeviceManager;
import com.zpotdrop.utils.DialogManager;
import com.zpotdrop.utils.EmailValidationUtils;
import com.zpotdrop.utils.SmartLog;
import com.zpotdrop.utils.SmartSharedPreferences;
import com.zpotdrop.utils.ViewUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class LoginActivity extends AppCompatActivity implements LoginTask.LoginListener {
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

    private final int LOGO_WIDTH = 155;
    private final int LOGO_HEIGHT = 199;
    private final int TEXT_LOGO_WIDTH = 322;
    private final int TEXT_LOGO_HEIGHT = 69;

    @Bind(R.id.iv_logo)
    ImageView ivLogoZD;

    @Bind(R.id.tv_welcome)
    TextView tvWelcome;

    @Bind(R.id.iv_text_logo)
    ImageView ivTextLogoZD;

    @Bind(R.id.edt_email)
    EditText edtEmail;

    @Bind(R.id.edt_password)
    EditText edtPassword;

    @Bind(R.id.tv_continue)
    TextView tvContinue;

    @Bind(R.id.tv_or)
    TextView tvOr;

    @Bind(R.id.tv_login_with_fb)
    TextView tvLoginWithFacebook;

    @Bind(R.id.tv_not_yet_on_zd)
    TextView tvNotYetOnZD;

    @Bind(R.id.tv_forgot_password)
    TextView tvForgotPassword;

    // Receiver for GCM register
    private BroadcastReceiver gcmRegisterReceiver;

    private String latitude;
    private String longitude;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        ButterKnife.bind(this);

        setupUI();

        initRegisterReceiver();

        if (checkPlayServices()) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        }

        // Get latitude, longitude
        getLocationInfo();

        checkAuthentication();
    }

    /**
     * Check if user logged in or not. If logged in, go to main page
     */
    private void checkAuthentication() {
        SmartLog.error(LoginActivity.class, SmartSharedPreferences.getAccessToken(this));
        if (!TextUtils.isEmpty(SmartSharedPreferences.getAccessToken(this))) {
            /**
             * Open main page
             */
            onSuccess();
        }
    }

    /**
     * Initialize GCM register receiver
     */
    private void initRegisterReceiver() {
        gcmRegisterReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                boolean sentToken = SmartSharedPreferences.getSentTokenToServer(context);
                if (sentToken) {
                    // mInformationTextView.setText(getString(R.string.gcm_send_message));
                    SmartLog.error(LoginActivity.class, "GMC send message");
                } else {
                    // mInformationTextView.setText(getString(R.string.token_error_message));
                    SmartLog.error(LoginActivity.class, "Token error");
                }
            }
        };
    }

    /**
     * Set up UI: text, size, color,...
     */
    private void setupUI() {
        /**
         * Adjust logo size
         */
        int logoWidth = DeviceManager.getScreenWidth(this) / 4;
        int logoHeight = (int) ((1.0f * logoWidth / LOGO_WIDTH) * LOGO_HEIGHT);
        ivLogoZD.getLayoutParams().width = logoWidth;
        ivLogoZD.getLayoutParams().height = logoHeight;

        /**
         * Set welcome text font
         */
        tvWelcome.setTypeface(ZpotdropApp.openSansLight);

        /**
         * Adjust text logo size
         */
        int textLogoWidth = (int) (DeviceManager.getScreenWidth(this) * 0.4f);
        int textLogoHeight = (int) ((1.0f * textLogoWidth / TEXT_LOGO_WIDTH) * TEXT_LOGO_HEIGHT);
        ivTextLogoZD.getLayoutParams().width = textLogoWidth;
        ivTextLogoZD.getLayoutParams().height = textLogoHeight;
    }

    @OnClick(R.id.tv_not_yet_on_zd)
    void openRegisterPage() {
        openNewPage(RegisterActivity.class);
    }

    @OnClick(R.id.tv_forgot_password)
    void openForgotPasswordPage() {
        openNewPage(ForgotPasswordActivity.class);
    }

    @OnClick(R.id.tv_continue)
    void login() {
        /**
         * Validate email
         */
        if (!ViewUtils.isValidEditText(this, edtEmail, getResources().getString(R.string.msg_please_enter_your_email))) {
            return;
        }
        String email = edtEmail.getText().toString();
        if (!EmailValidationUtils.isValidEmail(this, email, getResources().getString(R.string.msg_invalid_email_address))) {
            return;
        }

        /**
         * Validate password
         */
        if (!ViewUtils.isValidEditText(this, edtPassword, getResources().getString(R.string.msg_please_enter_your_password))) {
            return;
        }

        /**
         * Try to login
         */
        LoginTask loginTask = new LoginTask(this, getResources().getString(R.string.logging_in), true);
        String password = edtPassword.getText().toString();
        String gcmToken = SmartSharedPreferences.getGCMToken(this);

        loginTask.addParams(ApiConst.GRANT_TYPE_PASSWORD,
                ApiConst.CLIENT_ID_VALUE,
                ApiConst.CLIENT_SECRET_VALUE,
                email, password, gcmToken,
                ApiConst.DEVICE_TYPE_ANDROID, latitude, longitude);

        // Add listener
        loginTask.setLoginListener(this);
        loginTask.execute();
    }

    /**
     * Open new activity
     *
     * @param activityClass The class of activity that will be opened
     */
    private void openNewPage(Class activityClass) {
        Intent intent = new Intent(this, activityClass);
        startActivity(intent);

        // Animation when transforming screens
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
                        .show();
            } else {
                SmartLog.error(LoginActivity.class, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Get current location info
     */
    private void getLocationInfo() {
        MyLocation.LocationResult locationResult = new MyLocation.LocationResult() {
            @Override
            public void gotLocation(Location location) {
                if (location == null) {
                    SmartLog.error(RegisterMoreInfoActivity.class, "gotLocation null");
                    return;
                }
                SmartLog.error(LoginActivity.class, "gotLocation");
                latitude = Double.toString(location.getLatitude());
                longitude = Double.toString(location.getLatitude());
            }
        };
        MyLocation myLocation = new MyLocation();
        myLocation.getLocation(this, locationResult);
    }

    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(gcmRegisterReceiver,
                new IntentFilter(Const.REGISTRATION_COMPLETE));
    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(gcmRegisterReceiver);
        super.onPause();
    }

    /**
     * Login success
     */
    @Override
    public void onSuccess() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);

        // Animation when transforming screens
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);

        /**
         * Finish this activity
         */
        this.finish();
    }

    /**
     * Login failed
     *
     * @param errorMessage
     */
    @Override
    public void onFailed(String errorMessage) {
        DialogManager.showErrorDialog(this, getResources().getString(R.string.login_error), errorMessage);
    }
}

