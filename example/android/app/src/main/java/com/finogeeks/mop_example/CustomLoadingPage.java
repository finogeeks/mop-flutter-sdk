package com.finogeeks.mop_example;

import android.content.Context;
import android.widget.TextView;

import com.finogeeks.lib.applet.modules.appletloadinglayout.IFinAppletLoadingPage;

import androidx.annotation.NonNull;

public class CustomLoadingPage extends IFinAppletLoadingPage {
    public CustomLoadingPage(@NonNull Context context) {
        super(context);
    }

    @Override
    public int getFailureLayoutRes() {
        return R.layout.layout_custom_loading_page_failure;
    }

    @Override
    public int getLoadingLayoutRes() {
        return R.layout.layout_custom_loading_page;
    }

    @Override
    public void onLoadingFailure(@NonNull String s) {
        ((TextView)getFailureLayout().findViewById(R.id.failMsg)).setText(s);
    }

    @Override
    public void onLoadingFailure(@NonNull String s, @NonNull String s1) {
        ((TextView)getFailureLayout().findViewById(R.id.failTitle)).setText(s);
        ((TextView)getFailureLayout().findViewById(R.id.failMsg)).setText(s1);
    }

    @Override
    public void onUpdate(@NonNull String s, @NonNull String s1) {
        ((TextView)getLoadingLayout().findViewById(R.id.loadingTitle)).setText(s);
    }
}
