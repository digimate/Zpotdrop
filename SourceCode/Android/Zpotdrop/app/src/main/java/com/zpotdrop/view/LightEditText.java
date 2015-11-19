/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.EditText;

import com.zpotdrop.app.ZpotdropApp;

/**
 * @author phuc.tran
 */
public class LightEditText extends EditText {
    public LightEditText(Context context) {
        super(context);

        setTypeface(ZpotdropApp.openSansLight);
    }

    public LightEditText(Context context, AttributeSet attrs) {
        super(context, attrs);

        setTypeface(ZpotdropApp.openSansLight);
    }
}
