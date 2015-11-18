/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.model.LatLng;
import com.zpotdrop.R;
import com.zpotdrop.activity.MainActivity;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.utils.DeviceManager;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class ProfileFragment extends Fragment {
    private static ProfileFragment instance;
    @Bind(R.id.map_view)
    MapView mapView;
    GoogleMap map;
    @Bind(R.id.fl_user_info)
    FrameLayout flUserInfo;

    @Bind(R.id.lnl_bottom)
    LinearLayout lnlBottom;

    @Bind(R.id.iv_avatar)
    ImageView ivAvatar;

    @Bind(R.id.iv_request_zpot)
    ImageView ivRequestZpot;

    @Bind(R.id.iv_follow)
    ImageView ivFollow;

    @Bind(R.id.tv_username)
    TextView tvUsername;

    @Bind(R.id.tv_user_info)
    TextView tvUserInfo;

    @Bind(R.id.tv_drops_number)
    TextView tvDropsNumber;
    @Bind(R.id.tv_drops)
    TextView tvDrops;

    @Bind(R.id.tv_followers_number)
    TextView tvFollowersNumber;
    @Bind(R.id.tv_followers)
    TextView tvFollowers;

    @Bind(R.id.tv_followings_number)
    TextView tvFollowingsNumber;
    @Bind(R.id.tv_followings)
    TextView tvFollowings;

    public static ProfileFragment getInstance() {
        if (ProfileFragment.instance == null) {
            ProfileFragment.instance = new ProfileFragment();
        }
        return ProfileFragment.instance;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragement_profile, container, false);

        ButterKnife.bind(this, v);

        setupMap(savedInstanceState);

        setupUI();

        return v;
    }

    private void setupUI() {
        ((MainActivity) this.getActivity()).setHeaderTitle(this.getActivity().getResources().getString(R.string.profile));

        int avatarSize = (int) (DeviceManager.getScreenWidth(this.getActivity()) * 0.4f);
        ivAvatar.getLayoutParams().width = avatarSize;
        ivAvatar.getLayoutParams().height = avatarSize;

        int buttonSize = DeviceManager.getScreenWidth(this.getActivity()) / 8;
        ivRequestZpot.getLayoutParams().width = buttonSize;
        ivRequestZpot.getLayoutParams().height = buttonSize;

        ivFollow.getLayoutParams().width = buttonSize;
        ivFollow.getLayoutParams().height = buttonSize;

        tvUsername.setTypeface(ZpotdropApp.openSansBold);
        tvUserInfo.setTypeface(ZpotdropApp.openSansLight);

        tvDropsNumber.setTypeface(ZpotdropApp.openSansRegular);
        tvDropsNumber.setText("10");
        tvDrops.setTypeface(ZpotdropApp.openSansRegular);

        tvFollowersNumber.setTypeface(ZpotdropApp.openSansRegular);
        tvFollowersNumber.setText("100");
        tvFollowers.setTypeface(ZpotdropApp.openSansRegular);

        tvFollowingsNumber.setTypeface(ZpotdropApp.openSansRegular);
        tvFollowingsNumber.setText("1000");
        tvFollowings.setTypeface(ZpotdropApp.openSansRegular);

        adjustMapSize();
    }

    private void adjustMapSize() {
        final ViewTreeObserver vto = flUserInfo.getViewTreeObserver();
        vto.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                flUserInfo.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                mapView.getLayoutParams().height = flUserInfo.getMeasuredHeight();

                flUserInfo.requestLayout();
            }
        });
    }

    private void setupMap(final Bundle savedInstanceState) {
        mapView.onCreate(savedInstanceState);

        // Gets to GoogleMap from the MapView and does initialization stuff
        map = mapView.getMap();
        map.getUiSettings().setMyLocationButtonEnabled(false);
        map.setMyLocationEnabled(true);

        if (MapsInitializer.initialize(ProfileFragment.this.getActivity()) != ConnectionResult.SUCCESS) {
            // Handle the error
        }

        // Updates the location and zoom of the MapView
        CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(new LatLng(43.1, -87.9), 10);
        map.animateCamera(cameraUpdate); // Gets the MapView from the XML layout and creates it
    }

    @Override
    public void onResume() {
        mapView.onResume();
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

}