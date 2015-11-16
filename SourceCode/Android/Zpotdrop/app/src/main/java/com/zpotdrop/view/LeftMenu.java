/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.zpotdrop.R;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.utils.DeviceManager;

import butterknife.Bind;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * @author phuc.tran
 */
public class LeftMenu extends LinearLayout {
    @Bind(R.id.iv_avatar)
    CircleImageView ivAvatar;
    @Bind(R.id.tv_username)
    TextView tvUsername;
    @Bind(R.id.tv_settings)
    TextView tvSettings;
    @Bind(R.id.tv_menu_feed)
    TextView tvFeed;
    @Bind(R.id.tv_menu_post)
    TextView tvPost;
    @Bind(R.id.tv_menu_find)
    TextView tvFind;
    @Bind(R.id.tv_menu_chat)
    TextView tvChat;
    @Bind(R.id.tv_menu_search)
    TextView tvSearch;
    @Bind(R.id.zpot_all_progress)
    CircularProgressBar zpotAllProgress;
    @Bind(R.id.lnl_zpot_all_wrapper)
    LinearLayout zpotAllWrapper;
    private Context context;
    private ObjectAnimator progressBarAnimator;

    public LeftMenu(Context context) {
        super(context);

        this.context = context;

        View view = inflate(context, R.layout.left_menu, this);

        ButterKnife.bind(view);

        setupUI();
    }

    public LeftMenu(Context context, AttributeSet attrs) {
        super(context, attrs);

        this.context = context;

        View view = inflate(context, R.layout.left_menu, this);

        ButterKnife.bind(view);

        setupUI();
    }

    private void setupUI() {
        int avatarSize = DeviceManager.getScreenWidth(this.context) / 3;
        ivAvatar.getLayoutParams().width = avatarSize;
        ivAvatar.getLayoutParams().height = avatarSize;

        tvUsername.setTypeface(ZpotdropApp.openSansBold);
        tvSettings.setTypeface(ZpotdropApp.openSansLight);

        tvFeed.setTypeface(ZpotdropApp.openSansLight);
        tvPost.setTypeface(ZpotdropApp.openSansLight);
        tvFind.setTypeface(ZpotdropApp.openSansLight);
        tvChat.setTypeface(ZpotdropApp.openSansLight);
        tvSearch.setTypeface(ZpotdropApp.openSansLight);

        zpotAllProgress.setProgressColor(context.getResources().getColor(R.color.colorPrimary));
        zpotAllProgress.setProgressCircleBackground(context.getResources().getColor(R.color.text_gray));
        zpotAllProgress.setState(CircularProgressBar.STATE_PROGRESS);
        zpotAllProgress.setTextColor(context.getResources().getColor(R.color.text_gray));
        zpotAllProgress.setTextSize((int) context.getResources().getDimension(R.dimen.zpot_all_progress_text_size));
        zpotAllProgress.setStroke((int) context.getResources().getDimension(R.dimen.zpot_all_progress_stroke_size));
        zpotAllProgress.setProgress(20);

        zpotAllWrapper.getLayoutParams().height = (int) (zpotAllProgress.getLayoutParams().height + context.getResources().getDimension(R.dimen.margin_extra_large));
    }


}
