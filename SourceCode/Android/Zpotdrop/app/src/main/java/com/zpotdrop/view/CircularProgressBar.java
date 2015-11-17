/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.View;

import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.utils.SmartLog;

/**
 * @author phuc.tran
 */
public class CircularProgressBar extends View {

    public static final int STATE_NORMAL = 0;
    public static final int STATE_LOADING = 1;
    public static final int STATE_PROGRESS = 2;
    public static final int STATE_PAUSE = 3;
    private static Typeface typefaceIcon;
    private static Typeface typefaceNumber = null;
    private Context context;
    private DisplayMetrics metrics;
    private Paint paintCircle;
    private Paint paintProgress;
    private Paint paintText;
    private int textSize;
    private int textColor;
    private int state;
    private int progress = 0;
    private int startDegree = 0;
    private int circleColor = Color.WHITE;
    private int progressBarColor = Color.DKGRAY;
    private int width;
    //private int lenght = 60;
    private int height;
    private int centerX;
    private int centerY;
    private int stroke = 5;
    private RectF circleRect;
    private int textBaseLine;


    public CircularProgressBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initializer(context);
    }


    public CircularProgressBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializer(context);
    }

    public CircularProgressBar(Context context) {
        super(context);
        initializer(context);
    }

    public void setProgress(int progress) {
        this.progress = progress;
        state = STATE_PROGRESS;
        postInvalidate();
    }

    public CircularProgressBar setProgressColor(int value) {
        //paintCircle.setColor(value);
        paintProgress.setColor(value);
        //paintCircle.setAlpha(90);
        return this;
    }

    public void setProgressCircleBackground(int color) {
        paintCircle.setColor(color);
    }

    public void setState(int state) {
        this.state = state;

        if (state == STATE_NORMAL) {
            paintText.setTypeface(typefaceIcon);
            return;
        }

        if (state == STATE_LOADING) {
            paintText.setTypeface(typefaceIcon);
            startLoading();
            return;
        }

        if (state == STATE_PROGRESS) {
            paintText.setTypeface(typefaceNumber);
            return;
        }

        if (state == STATE_PAUSE) {
            paintText.setTypeface(typefaceIcon);
            return;
        }

    }

    private void startLoading() {
        new Thread(new Runnable() {

            @Override
            public void run() {
                while (state == STATE_LOADING) {
                    if (startDegree == 360) {
                        startDegree = 0;
                    }
                    startDegree += 5;

                    postInvalidate();

                    try {
                        Thread.sleep(16);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

    private void initializer(Context context) {
        this.context = context;
        metrics = context.getResources().getDisplayMetrics();

        if (typefaceIcon == null) {
            typefaceIcon = ZpotdropApp.openSansBold;
        }

        if (typefaceNumber == null) {
            typefaceNumber = ZpotdropApp.openSansBold;
        }

        int padding = dpToPixel(8);
        setPadding(padding, padding, padding, padding);

        textSize = dpToPixel(textSize);

        paintCircle = new Paint();
        paintCircle.setAntiAlias(true);
        paintCircle.setStyle(Style.STROKE);
        paintCircle.setColor(circleColor);

        paintProgress = new Paint();
        paintProgress.setAntiAlias(true);
        paintProgress.setStyle(Style.STROKE);
        paintProgress.setColor(progressBarColor);

        paintText = new Paint();
        paintText.setAntiAlias(true);
        paintText.setColor(textColor);
        paintText.setTextAlign(Paint.Align.CENTER);
        paintText.setTextSize(textSize);

        setState(STATE_NORMAL);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);

        width = getWidth() - getPaddingLeft() - getPaddingRight();
        height = getHeight() - getPaddingTop() - getPaddingBottom();
        centerX = width / 2;
        centerY = height / 2;

        //stroke = dpToPixel(width / dpToPixel(48) * 2);
        //textSize = dpToPixel(width / 4);

        paintCircle.setStrokeWidth(stroke);
        paintProgress.setStrokeWidth(stroke * 2);

        paintText.setTextSize(textSize);

        circleRect = new RectF(stroke, stroke, width - stroke, height - stroke);

        textBaseLine = (int) ((paintText.descent() + paintText.ascent()) / 2);
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawView(canvas);

    }


    private void drawView(Canvas canvas) {

        canvas.drawArc(circleRect, 0, 360, false, paintCircle);

//        if (state == STATE_NORMAL) {
//            String icon = context.getResources().getString(R.string.app_name);
//            canvas.drawText(icon, centerX, centerY - textBaseLine, paintText);
//            return;
//        }
//
//        if (state == STATE_LOADING) {
//            String icon = context.getResources().getString(R.string.app_name);
//            canvas.drawArc(circleRect, startDegree, lenght, false, paintProgress);
//            canvas.drawText(icon, centerX, centerY - textBaseLine, paintText);
//            return;
//        }

        //if (state == STATE_PROGRESS) {
        canvas.drawArc(circleRect, -90, 360 * progress / 100, false, paintProgress);
        canvas.drawText(progress + "%", centerX, centerY - textBaseLine, paintText);
        SmartLog.error(CircularProgressBar.class, progress + "%" + " - X = " + centerX + " - Y = " + centerY);
        //  return;
        //}

//        if (state == STATE_PAUSE) {
//            String icon = context.getResources().getString(R.string.app_name);
//            canvas.drawText(icon, centerX, centerY - textBaseLine, paintText);
//            return;
//        }

    }


    private int dpToPixel(int dp) {
        int pixel = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, dp, metrics);
        return pixel;
    }

    public int getStroke() {
        return stroke;
    }

    public void setStroke(int stroke) {
        this.stroke = stroke;
    }

    public int getTextColor() {
        return textColor;
    }

    public void setTextColor(int textColor) {
        this.textColor = textColor;
        paintText.setColor(textColor);
    }

    public int getTextSize() {
        return textSize;
    }

    public void setTextSize(int textSize) {
        this.textSize = textSize;
    }
}