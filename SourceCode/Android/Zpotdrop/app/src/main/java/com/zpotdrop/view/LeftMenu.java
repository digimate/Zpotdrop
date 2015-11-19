/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.zpotdrop.R;
import com.zpotdrop.activity.MainActivity;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.fragment.FindFragment;
import com.zpotdrop.fragment.ProfileFragment;
import com.zpotdrop.fragment.SettingsFragment;
import com.zpotdrop.utils.DeviceManager;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * @author phuc.tran
 */
public class LeftMenu extends LinearLayout {
    @Bind(R.id.lnl_profile)
    LinearLayout lnlProfile;
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
    @Bind(R.id.tv_zpot_all_msg)
    TextView tvMsgZpotAll;
    private Context context;

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
        int avatarSize = (int) (DeviceManager.getScreenWidth(this.context) * 0.4f);
        ivAvatar.getLayoutParams().width = avatarSize;
        ivAvatar.getLayoutParams().height = avatarSize;

        tvUsername.setTypeface(ZpotdropApp.openSansBold);
        tvSettings.setTypeface(ZpotdropApp.openSansLight);

        tvFeed.setTypeface(ZpotdropApp.openSansRegular);
        tvPost.setTypeface(ZpotdropApp.openSansRegular);
        tvFind.setTypeface(ZpotdropApp.openSansRegular);
        tvChat.setTypeface(ZpotdropApp.openSansRegular);
        tvSearch.setTypeface(ZpotdropApp.openSansRegular);
        tvMsgZpotAll.setTypeface(ZpotdropApp.openSansLight);

        zpotAllProgress.setProgressColor(context.getResources().getColor(R.color.colorPrimary));
        zpotAllProgress.setProgressCircleBackground(context.getResources().getColor(R.color.divider));
        zpotAllProgress.setState(CircularProgressBar.STATE_PROGRESS);
        zpotAllProgress.setTextColor(context.getResources().getColor(R.color.text_gray));
        zpotAllProgress.setTextSize((int) context.getResources().getDimension(R.dimen.zpot_all_progress_text_size));
        zpotAllProgress.setStroke((int) context.getResources().getDimension(R.dimen.zpot_all_progress_stroke_size));
        zpotAllProgress.setProgress(20);

        zpotAllWrapper.getLayoutParams().height = (int) (zpotAllProgress.getLayoutParams().height + context.getResources().getDimension(R.dimen.margin_extra_large) + context.getResources().getDimension(R.dimen.margin_extra_small));
    }

    @OnClick(R.id.lnl_profile)
    void openProfilePage() {
        ((MainActivity) this.context).closeLeftMenu();
        ((MainActivity) this.context).setHeaderTitle(getResources().getString(R.string.profile));
        ((MainActivity) this.context).replaceFragment(ProfileFragment.getInstance(), null);
    }

    @OnClick(R.id.tv_settings)
    void openSettingsPage() {
        ((MainActivity) this.context).closeLeftMenu();
        ((MainActivity) this.context).setHeaderTitle(getResources().getString(R.string.settings));
        ((MainActivity) this.context).replaceFragment(SettingsFragment.getInstance(), null);
    }

    @OnClick(R.id.tv_menu_feed)
    void openFeedPage() {
        ((MainActivity) this.context).closeLeftMenu();
    }

    @OnClick(R.id.tv_menu_post)
    void openPostPage() {
        ((MainActivity) this.context).closeLeftMenu();
    }

    @OnClick(R.id.tv_menu_find)
    void openFindPage() {
        ((MainActivity) this.context).closeLeftMenu();
        ((MainActivity) this.context).setHeaderTitle(getResources().getString(R.string.find));
        ((MainActivity) this.context).replaceFragment(FindFragment.getInstance(), null);
    }

    @OnClick(R.id.tv_menu_chat)
    void openChatPage() {
        ((MainActivity) this.context).closeLeftMenu();
    }

    @OnClick(R.id.tv_menu_search)
    void openSearchPage() {
        ((MainActivity) this.context).closeLeftMenu();
    }
}
