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
import com.zpotdrop.consts.Const;
import com.zpotdrop.utils.DeviceManager;
import com.zpotdrop.utils.EmailValidationUtils;
import com.zpotdrop.utils.ViewUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author phuc.tran
 */
public class RegisterActivity extends AppCompatActivity {

    private static RegisterActivity instance;

    private final int LOGO_WIDTH = 155;
    private final int LOGO_HEIGHT = 199;

    @Bind(R.id.iv_logo)
    ImageView ivLogoZD;

    @Bind(R.id.edt_email)
    EditText edtEmail;

    @Bind(R.id.edt_password)
    EditText edtPassword;

    @Bind(R.id.edt_password_again)
    EditText edtPasswordAgain;

    @Bind(R.id.tv_continue)
    TextView tvContinue;

    @Bind(R.id.tv_back)
    TextView tvBack;

    /**
     * Finish this activity
     */
    public static void terminate() {
        if (RegisterActivity.instance != null) {
            RegisterActivity.instance.finish();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        ButterKnife.bind(this);

        setupUI();

        RegisterActivity.instance = this;
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

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @OnClick(R.id.tv_continue)
    void openRegisterMoreInfoPage() {
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
        if (!ViewUtils.isValidEditText(this, edtPasswordAgain, getResources().getString(R.string.msg_please_confirm_your_password))) {
            return;
        }
        if (!ViewUtils.isPasswordsMatch(this, edtPassword, edtPasswordAgain, getResources().getString(R.string.msg_please_enter_your_email))) {
            return;
        }

        /**
         * All basic info is valid, open new page for more info
         */
        Intent intent = new Intent(this, RegisterMoreInfoActivity.class);
        intent.putExtra(Const.KEY_EMAIL, email);
        String password = edtPassword.getText().toString();
        intent.putExtra(Const.KEY_PASSWORD, password);
        startActivity(intent);

        // Animation when transforming screens
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
    }
}
