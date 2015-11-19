/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

import com.zpotdrop.app.ZpotdropApp;

/**
 * @author phuc.tran
 */
public class LightTextView extends TextView {
    public LightTextView(Context context) {
        super(context);
        setTypeface(ZpotdropApp.openSansLight);
    }

    public LightTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setTypeface(ZpotdropApp.openSansLight);
    }
}
