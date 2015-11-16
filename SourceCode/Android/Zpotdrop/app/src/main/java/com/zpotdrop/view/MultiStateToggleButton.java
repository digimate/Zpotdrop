/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.zpotdrop.R;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.utils.DeviceManager;

import butterknife.Bind;
import butterknife.ButterKnife;

public class MultiStateToggleButton extends LinearLayout implements View.OnTouchListener {
    @Bind(R.id.tv_left)
    TextView tvLeft;
    @Bind(R.id.tv_center)
    TextView tvCenter;
    @Bind(R.id.tv_right)
    TextView tvRight;
    @Bind(R.id.iv_left)
    ImageView ivLeft;
    @Bind(R.id.iv_center)
    ImageView ivCenter;
    @Bind(R.id.iv_right)
    ImageView ivRight;
    private Context context;
    private int selectedPosition;

    public MultiStateToggleButton(Context context) {
        super(context);
        this.context = context;
        View view = inflate(context, R.layout.multi_states_toggle_button, this);

        ButterKnife.bind(view);

        setupUI();
    }

    public MultiStateToggleButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        View view = inflate(context, R.layout.multi_states_toggle_button, this);

        ButterKnife.bind(view);

        setupUI();
    }

    private void setupUI() {
        this.setOnTouchListener(this);

        tvLeft.setTypeface(ZpotdropApp.openSansLight);
        tvCenter.setTypeface(ZpotdropApp.openSansLight);
        tvRight.setTypeface(ZpotdropApp.openSansLight);

        int dotSize = DeviceManager.getScreenWidth(context) / 20;
        ivLeft.getLayoutParams().width = dotSize;
        ivLeft.getLayoutParams().height = dotSize;

        ivCenter.getLayoutParams().width = dotSize;
        ivCenter.getLayoutParams().height = dotSize;

        ivRight.getLayoutParams().width = dotSize;
        ivRight.getLayoutParams().height = dotSize;

        selectedPosition = 1;
    }

    /**
     * Set text for left label
     *
     * @param leftText
     */
    public void setLeftText(String leftText) {
        tvLeft.setText(leftText);
    }

    /**
     * Set text for center label
     *
     * @param centerText
     */
    public void setCenterText(String centerText) {
        tvCenter.setText(centerText);
    }

    /**
     * Set text for right label
     *
     * @param rightText
     */
    public void setRightText(String rightText) {
        tvRight.setText(rightText);
    }

    public int getSelectedPosition() {
        return selectedPosition;
    }

    /**
     * Set selected position, 0 = left, 1 = center, 2 = right
     *
     * @param selectedPosition
     */
    public void setSelectedPosition(int selectedPosition) {
        this.selectedPosition = selectedPosition;
        if (selectedPosition == 0) {
            ivLeft.setVisibility(View.VISIBLE);
            ivCenter.setVisibility(View.INVISIBLE);
            ivRight.setVisibility(View.INVISIBLE);
        } else if (selectedPosition == 1) {
            ivLeft.setVisibility(View.INVISIBLE);
            ivCenter.setVisibility(View.VISIBLE);
            ivRight.setVisibility(View.INVISIBLE);
        } else {
            ivLeft.setVisibility(View.INVISIBLE);
            ivCenter.setVisibility(View.INVISIBLE);
            ivRight.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            float length = DeviceManager.getScreenWidth(context);
            //SmartLog.error(MultiStateToggleButton.class, "" + event.getX());
            //SmartLog.error(MultiStateToggleButton.class, "" + length);
            float touchX = event.getX();
            if (touchX < length / 3) {
                setSelectedPosition(0);
            } else if (touchX > length / 3 && touchX < ((length / 3) * 2)) {
                setSelectedPosition(1);
            } else {
                setSelectedPosition(2);
            }
        }
        return false;
    }
}