/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.zpotdrop.R;
import com.zpotdrop.app.ZpotdropApp;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class Header extends RelativeLayout {
    @Bind(R.id.iv_menu)
    ImageView ivMenu;
    @Bind(R.id.iv_notifications)
    ImageView ivNotifications;
    @Bind(R.id.tv_title)
    TextView tvTitle;
    private Context context;

    public Header(Context context) {
        super(context);

        this.context = context;

        View view = inflate(context, R.layout.header, this);

        ButterKnife.bind(view);

        setupUI();
    }

    public Header(Context context, AttributeSet attrs) {
        super(context, attrs);

        this.context = context;

        View view = inflate(context, R.layout.header, this);

        ButterKnife.bind(view);

        setupUI();
    }

    private void setupUI() {
        tvTitle.setTypeface(ZpotdropApp.openSansRegular);
    }

    public void setTitle(String title) {
        tvTitle.setText(title);
    }
}
