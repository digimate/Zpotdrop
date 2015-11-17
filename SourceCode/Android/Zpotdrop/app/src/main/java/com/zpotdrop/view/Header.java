/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;

import com.zpotdrop.R;

import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class Header extends RelativeLayout {
    private Context context;

    public Header(Context context) {
        super(context);

        this.context = context;

        View view = inflate(context, R.layout.left_menu, this);

        ButterKnife.bind(view);

        setupUI();
    }

    public Header(Context context, AttributeSet attrs) {
        super(context, attrs);

        this.context = context;

        View view = inflate(context, R.layout.left_menu, this);

        ButterKnife.bind(view);

        setupUI();
    }

    private void setupUI() {

    }
}
