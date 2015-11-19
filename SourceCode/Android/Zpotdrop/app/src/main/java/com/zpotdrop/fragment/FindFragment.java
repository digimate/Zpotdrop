/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.zpotdrop.R;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class FindFragment extends Fragment {

    private static FindFragment instance;
    @Bind(R.id.map_view)
    MapView mapView;
    GoogleMap map;

    @Bind(R.id.edt_search)
    EditText edtSearch;

    @Bind(R.id.tv_here)
    TextView tvHere;

    public static FindFragment getInstance() {
        if (FindFragment.instance == null) {
            FindFragment.instance = new FindFragment();
        }
        return FindFragment.instance;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, final Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_find, container, false);

        ButterKnife.bind(this, v);

        setupMap(savedInstanceState);

        setupUI();

        return v;
    }

    private void setupMap(final Bundle savedInstanceState) {
        mapView.onCreate(savedInstanceState);

        // Gets to GoogleMap from the MapView and does initialization stuff
        mapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(GoogleMap googleMap) {
                map = googleMap;

                map.getUiSettings().setMyLocationButtonEnabled(false);
                map.setMyLocationEnabled(true);

                if (MapsInitializer.initialize(FindFragment.this.getActivity()) != ConnectionResult.SUCCESS) {
                    // Handle the error
                }

                // Updates the location and zoom of the MapView
                CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(new LatLng(43.1, -87.9), 10);
                map.animateCamera(cameraUpdate); // Gets the MapView from the XML layout and creates it
            }
        });
    }

    private void setupUI() {

    }

    @Override
    public void onResume() {
        if (mapView != null) {
            mapView.onResume();
        }
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mapView != null) {
            mapView.onDestroy();
        }
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        if (mapView != null) {
            mapView.onLowMemory();
        }
    }
}
