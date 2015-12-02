/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.activity;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.Gravity;

import com.zpotdrop.R;
import com.zpotdrop.fragment.ProfileFragment;
import com.zpotdrop.utils.SmartTaskUtilsWithProgressDialog;
import com.zpotdrop.view.Header;
import com.zpotdrop.view.LeftMenu;
import com.zpotdrop.view.ZProgressHUD;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * @author phuc.tran
 */
public class MainActivity extends AppCompatActivity {
    public static final String BACK_STACK_FEED = "feed";
    public static final String BACK_STACK_POST = "post";
    public static final String BACK_STACK_FIND = "find";
    public static final String BACK_STACK_CHAT = "chat";
    public static final String BACK_STACK_SEARCH = "search";

    @Bind(R.id.header)
    Header header;

    @Bind(R.id.drawer_layout)
    DrawerLayout drawerLayout;
    @Bind(R.id.left_drawer)
    LeftMenu leftMenu;
    private FragmentManager fragmentManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);

        fragmentManager = getSupportFragmentManager();

        setupUI();
    }

    private void setupUI() {
        SmartTaskUtilsWithProgressDialog testTask = new SmartTaskUtilsWithProgressDialog(this, "Loading...", true) {
            @Override
            protected Void doInBackground(Void... params) {
                ProfileFragment.getInstance();

                return super.doInBackground(params);
            }

            @Override
            protected void onPostExecute(Void result) {
                super.onPostExecute(result);
            }
        };
        testTask.execute();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        ZProgressHUD.destroy();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);

        ZProgressHUD.destroy();
    }

    public void replaceFragment(Fragment fragment, String backStackName) {
        FragmentTransaction transaction = fragmentManager.beginTransaction();
        transaction.setCustomAnimations(R.anim.fragment_enter, R.anim.fragment_exit, R.anim.fragment_pop_enter, R.anim.fragment_pop_exit);

        transaction.replace(R.id.content_frame, fragment);
        if (!TextUtils.isEmpty(backStackName)) {
            transaction.addToBackStack(backStackName);
        }
        transaction.commit();
    }

    /**
     * Toggle left menu
     */
    public void toggleLeftMenu() {
        if (drawerLayout.isDrawerOpen(Gravity.LEFT)) {
            drawerLayout.closeDrawer(Gravity.LEFT);
        } else {
            drawerLayout.openDrawer(Gravity.LEFT);
        }
    }

    /**
     * Close left menu
     */
    public void closeLeftMenu() {
        if (drawerLayout.isDrawerOpen(Gravity.LEFT)) {
            drawerLayout.closeDrawer(Gravity.LEFT);
        }
    }

    /**
     * Open left menu
     */
    public void openLeftMenu() {
        drawerLayout.openDrawer(Gravity.LEFT);
    }

    public void setHeaderTitle(String title) {
        header.setTitle(title);
    }
    //    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_main, menu);
//        return true;
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        // Handle action bar item clicks here. The action bar will
//        // automatically handle clicks on the Home/Up button, so long
//        // as you specify a parent activity in AndroidManifest.xml.
//        int id = item.getItemId();
//
//        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }
//
//        return super.onOptionsItemSelected(item);
//    }
}