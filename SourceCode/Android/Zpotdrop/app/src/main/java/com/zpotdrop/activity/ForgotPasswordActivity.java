/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.activity;

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

/**
 * @author phuc.tran
 */
public class ForgotPasswordActivity extends AppCompatActivity {
    private final int LOGO_WIDTH = 155;
    private final int LOGO_HEIGHT = 199;

    @Bind(R.id.iv_logo)
    ImageView ivLogoZD;

    @Bind(R.id.tv_forgot_password)
    TextView tvForgotPassword;

    @Bind(R.id.edt_email)
    EditText edtEmail;

    @Bind(R.id.tv_send)
    TextView tvSend;

    @Bind(R.id.tv_back)
    TextView tvBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_forgot_password);

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
         * Set fonts for other texts & inputs
         */
        tvBack.setTypeface(ZpotdropApp.openSansLight);
        edtEmail.setTypeface(ZpotdropApp.openSansLight);
        tvForgotPassword.setTypeface(ZpotdropApp.openSansBold);
        tvSend.setTypeface(ZpotdropApp.openSansBold);
    }

    /**
     * Handle click event on back button -> Just do same thing as Back keyboard does
     */
    @OnClick(R.id.tv_back)
    void backButtonClicked() {
        onBackPressed();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }
}
