/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.zpotdrop.R;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.utils.DeviceManager;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class LoginActivity extends AppCompatActivity {
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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        ButterKnife.bind(this);

        setupUI();
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

        /**
         * Set fonts for other texts & inputs
         */
        edtEmail.setTypeface(ZpotdropApp.openSansLight);
        edtPassword.setTypeface(ZpotdropApp.openSansLight);
        tvContinue.setTypeface(ZpotdropApp.openSansBold);
        tvOr.setTypeface(ZpotdropApp.openSansLight);
        tvLoginWithFacebook.setTypeface(ZpotdropApp.openSansLight);
        tvNotYetOnZD.setTypeface(ZpotdropApp.openSansLight);
        tvForgotPassword.setTypeface(ZpotdropApp.openSansLight);
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
    void openMainPage() {
        openNewPage(MainActivity.class);
//        SmartTaskUtilsWithProgressDialog taskUtilsWithProgressDialog = new SmartTaskUtilsWithProgressDialog(this, "Logging in...", true) {
//            @Override
//            protected Void doInBackground(Void... params) {
//                SmartRestClient restClient = new SmartRestClient(ApiConst.URL_LOGIN);
//                try {
//                    restClient.execute(SmartRestClient.RequestMethod.POST, LoginActivity.this);
//                    String response = restClient.getResponse();
//                    SmartLog.error(LoginActivity.class, "Response: " + response);
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    SmartLog.error(LoginActivity.class, "openMainPage() " + e.getMessage());
//                }
//
//                return super.doInBackground(params);
//            }
//
//            @Override
//            protected void onPostExecute(Void result) {
//                super.onPostExecute(result);
//            }
//        };
//        taskUtilsWithProgressDialog.execute();
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
}

