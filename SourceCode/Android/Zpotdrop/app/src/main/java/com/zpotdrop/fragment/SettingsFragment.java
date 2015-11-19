/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.zpotdrop.R;

import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class SettingsFragment extends Fragment {
    private static SettingsFragment instance;

    public static SettingsFragment getInstance() {
        if (SettingsFragment.instance == null) {
            SettingsFragment.instance = new SettingsFragment();
        }
        return SettingsFragment.instance;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, final Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_settings, container, false);

        ButterKnife.bind(this, v);

        setupUI();

        return v;
    }

    private void setupUI() {

    }

}
