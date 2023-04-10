package com.finogeeks.mop_example;

import android.content.Context;

import com.finogeeks.lib.applet.modules.appletloadinglayout.IFinAppletLoadingPage;

import androidx.annotation.NonNull;

public class CustomLoadingPage extends IFinAppletLoadingPage {
    public CustomLoadingPage(@NonNull Context context) {
        super(context);
    }

    @Override
    public int getFailureLayoutRes() {
        return 0;
    }

    @Override
    public int getLoadingLayoutRes() {
        return 0;
    }

    @Override
    public void onLoadingFailure(@NonNull String s) {

    }

    @Override
    public void onLoadingFailure(@NonNull String s, @NonNull String s1) {

    }

    @Override
    public void onUpdate(@NonNull String s, @NonNull String s1) {

    }
}
