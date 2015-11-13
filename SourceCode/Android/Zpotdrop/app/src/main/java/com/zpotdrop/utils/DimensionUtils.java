/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.utils;

import android.content.Context;
import android.content.res.Resources;
import android.util.DisplayMetrics;

/**
 * Created by PHUC on 6/25/2015.
 */
public class DimensionUtils {
    /**
     * Convert dp to pixel
     *
     * @param dp      Original dp float number
     * @param context The context where the conversion is being made
     * @return
     */
    public static float dpToPixel(float dp, Context context) {
        Resources resources = context.getResources();
        DisplayMetrics metrics = resources.getDisplayMetrics();
        float px = dp * (metrics.densityDpi / 160f);
        return px;
    }

    public static float pixelsToDp(float px, Context context) {
        Resources resources = context.getResources();
        DisplayMetrics metrics = resources.getDisplayMetrics();
        float dp = px / (metrics.densityDpi / 160f);
        return dp;
    }

    /**
     * Convert pixel to sp
     *
     * @param context
     * @param px
     * @return
     */
    public static float pixelsToSp(Context context, float px) {
        float scaledDensity = context.getResources().getDisplayMetrics().scaledDensity;
        return px / scaledDensity;
    }
}
