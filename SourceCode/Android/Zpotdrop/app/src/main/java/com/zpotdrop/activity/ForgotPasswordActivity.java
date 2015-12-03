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
import com.zpotdrop.api.ApiConst;
import com.zpotdrop.api.ForgotPasswordTask;
import com.zpotdrop.utils.DeviceManager;
import com.zpotdrop.utils.DialogManager;
import com.zpotdrop.utils.EmailValidationUtils;
import com.zpotdrop.utils.ViewUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author phuc.tran
 */
public class ForgotPasswordActivity extends AppCompatActivity implements ForgotPasswordTask.ForgotPasswordListener {
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
    }

    /**
     * Handle click event on back button -> Just do same thing as Back keyboard does
     */
    @OnClick(R.id.tv_back)
    void backButtonClicked() {
        onBackPressed();
    }

    @OnClick(R.id.tv_send)
    void sendForgotPasswordRequest() {
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

        ForgotPasswordTask forgotPasswordTask = new ForgotPasswordTask(this, getResources().getString(R.string.sending), true);
        forgotPasswordTask.addParams(ApiConst.GRANT_TYPE_PASSWORD,
                ApiConst.CLIENT_ID_VALUE,
                ApiConst.CLIENT_SECRET_VALUE,
                email);

        // Add listener
        forgotPasswordTask.setForgotPasswordListener(this);
        forgotPasswordTask.execute();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @Override
    public void onSuccess(String successMessage) {
        DialogManager.showSuccessDialog(this, getResources().getString(R.string.success), successMessage, true);
    }

    @Override
    public void onFailed(String errorMessage) {
        DialogManager.showErrorDialog(this, getResources().getString(R.string.error), errorMessage);
    }
}
