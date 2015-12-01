/*
 * Copyright (c) 2015 Zpotdrop. All rights reserved.
 */

package com.zpotdrop.activity;

import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.fourmob.datetimepicker.date.DatePickerDialog;
import com.zpotdrop.R;
import com.zpotdrop.api.ApiConst;
import com.zpotdrop.api.RegisterTask;
import com.zpotdrop.app.ZpotdropApp;
import com.zpotdrop.consts.Const;
import com.zpotdrop.model.MyLocation;
import com.zpotdrop.utils.DeviceManager;
import com.zpotdrop.utils.DialogManager;
import com.zpotdrop.utils.SmartLog;
import com.zpotdrop.utils.SmartSharedPreferences;
import com.zpotdrop.utils.ViewUtils;
import com.zpotdrop.view.MultiStateToggleButton;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author phuc.tran
 */
public class RegisterMoreInfoActivity extends AppCompatActivity
        implements DatePickerDialog.OnDateSetListener,
        RegisterTask.RegisterListener {
    public static final String DATEPICKER_TAG = "datepicker";
    private final int LOGO_WIDTH = 155;
    private final int LOGO_HEIGHT = 199;

//    @Bind(R.id.combo_seek_bar)
//    ComboSeekBar comboSeekBar;
//
//    @BindString(R.string.male)
//    String male;
//    @BindString(R.string.private_gender)
//    String privateGender;
//    @BindString(R.string.female)
//    String female;
    @Bind(R.id.tv_back)
    TextView tvBack;

    @Bind(R.id.iv_logo)
    ImageView ivLogoZD;

    @Bind(R.id.edt_first_name)
    EditText edtFirstName;

    @Bind(R.id.edt_last_name)
    EditText edtLastName;

    @Bind(R.id.edt_phone_number)
    EditText edtPhoneNumber;

    @Bind(R.id.edt_dob)
    EditText edtDOB;

    @Bind(R.id.tv_sign_up)
    TextView tvSignUp;

    @Bind(R.id.toggle_genders)
    MultiStateToggleButton toggleGenders;

    private DatePickerDialog datePickerDialog;

    private String latitude;
    private String longitude;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_more_info);

        ButterKnife.bind(this);

        setupUI();

        // Get latitude, longitude
        getLocationInfo();
    }

    private void setupUI() {
        /**
         * Setup combo seekbar
         */
//        List<String> genders = new ArrayList<String>();
//        genders.add(male);
//        genders.add(privateGender);
//        genders.add(female);
//        comboSeekBar.setAdapter(genders);
//        comboSeekBar.setSelection(1);

        /**
         * Adjust logo size
         */
        int logoWidth = DeviceManager.getScreenWidth(this) / 4;
        int logoHeight = (int) ((1.0f * logoWidth / LOGO_WIDTH) * LOGO_HEIGHT);
        ivLogoZD.getLayoutParams().width = logoWidth;
        ivLogoZD.getLayoutParams().height = logoHeight;

        /**
         * Gender
         */
        toggleGenders.setSelectedPosition(1);
    }

    /**
     * Handle click event on back button -> Just do same thing as Back keyboard does
     */
    @OnClick(R.id.tv_back)
    void backButtonClicked() {
        onBackPressed();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();

        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @OnClick(R.id.tv_sign_up)
    void signUp() {
        /**
         * Validate fields
         */
        if (!ViewUtils.isValidEditText(this, edtFirstName, getResources().getString(R.string.msg_please_enter_first_name))) {
            return;
        }
        if (!ViewUtils.isValidEditText(this, edtLastName, getResources().getString(R.string.msg_please_enter_last_name))) {
            return;
        }
        if (!ViewUtils.isValidEditText(this, edtPhoneNumber, getResources().getString(R.string.msg_please_enter_phone_number))) {
            return;
        }

        /**
         * Sign up
         */
        RegisterTask registerTask = new RegisterTask(this, getResources().getString(R.string.signing_up), true);
        /**
         * Setup parameters
         */
        String email = null;
        String password = null;
        Intent intent = getIntent();
        if (intent != null) {
            email = intent.getStringExtra(Const.KEY_EMAIL);
            password = intent.getStringExtra(Const.KEY_PASSWORD);
        }
        String firstName = edtFirstName.getText().toString();
        String lastName = edtLastName.getText().toString();
        String birthday = edtDOB.getText().toString();
        String phoneNumber = edtPhoneNumber.getText().toString();
        int gender = toggleGenders.getSelectedPosition();
        String strGender;
        if (gender == 0) {
            strGender = ApiConst.GENDER_MALE;
        } else if (gender == 1) {
            strGender = ApiConst.GENDER_FEMALE;
        } else {
            strGender = ApiConst.GENDER_OTHERS;
        }
        String gcmToken = SmartSharedPreferences.getGCMToken(this);
        registerTask.addParams(ApiConst.GRANT_TYPE_PASSWORD,
                ApiConst.CLIENT_ID_VALUE,
                ApiConst.CLIENT_SECRET_VALUE,
                email, password, firstName, lastName,
                birthday, phoneNumber, strGender, gcmToken,
                ApiConst.DEVICE_TYPE_ANDROID, latitude, longitude);

        // Add listener
        registerTask.setRegisterListener(this);
        registerTask.execute();
    }

    @OnClick(R.id.edt_dob)
    void showDatePicker() {
        final Calendar calendar = Calendar.getInstance();
        /**
         * If there is no date entered, show current date
         */
        if (TextUtils.isEmpty(edtDOB.getText())) {
            datePickerDialog = DatePickerDialog.newInstance(this, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), true);
        }
        /**
         * Show entered date
         */
        else {
            String strDate = edtDOB.getText().toString().trim();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(ZpotdropApp.DATE_FORMAT);
            try {
                Date enteredDate = simpleDateFormat.parse(strDate);
                calendar.setTime(enteredDate);
                //calendar.set(Calendar.DAY_OF_MONTH, enteredDate.getDay());
                //calendar.set(Calendar.MONTH, enteredDate.getMonth());
                //calendar.set(Calendar.YEAR, enteredDate.getYear());
                datePickerDialog = DatePickerDialog.newInstance(this, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), true);
            } catch (ParseException e) {
                e.printStackTrace();
                datePickerDialog = DatePickerDialog.newInstance(this, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), true);
            }
        }
        datePickerDialog.setOnDateSetListener(this);
        datePickerDialog.show(getSupportFragmentManager(), DATEPICKER_TAG);
    }

    @Override
    public void onDateSet(DatePickerDialog datePickerDialog, int year, int month, int day) {
        String strDay = "" + day;
        String strMonth = month + 1 + "";
        if (day < 10) {
            strDay = "0" + day;
        }

        if (month + 1 < 10) {
            strMonth = "0" + (month + 1);
        }
        String strDate = strDay + "-" + strMonth + "-" + year;
        //SimpleDateFormat simpleDateFormat = new SimpleDateFormat(ZpotdropApp.DATE_FORMAT);
        //simpleDateFormat.
        edtDOB.setText(strDate);
    }

    @Override
    public void onSuccess() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);

        // Animation when transforming screens
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);

        /**
         * Finish this activity and RegisterActivity
         */
        this.finish();
        RegisterActivity.terminate();
    }

    @Override
    public void onFailed(String errorMessage) {
        DialogManager.showErrorDialog(this, getResources().getString(R.string.register_error), errorMessage);
    }

    /**
     * Get current location info
     */
    private void getLocationInfo() {
        MyLocation.LocationResult locationResult = new MyLocation.LocationResult() {
            @Override
            public void gotLocation(Location location) {
                if (location == null) {
                    SmartLog.error(RegisterMoreInfoActivity.class, "gotLocation null");
                    return;
                }
                SmartLog.error(RegisterMoreInfoActivity.class, "gotLocation");
                latitude = Double.toString(location.getLatitude());
                longitude = Double.toString(location.getLatitude());
            }
        };
        MyLocation myLocation = new MyLocation();
        myLocation.getLocation(this, locationResult);
    }
}
