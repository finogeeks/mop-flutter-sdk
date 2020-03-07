package com.finogeeks.mop.api;

import android.content.Intent;

import com.finogeeks.mop.interfaces.IApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.Map;

public class EmptyApi implements IApi {


    @Override
    public void onCreate() {

    }

    @Override
    public void onDestroy() {

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data, ICallback callback) {

    }
    @Override
    public void onNewIntent(Intent data) {

    }
    @Override
    public void onResume() {

    }
    @Override
    public void onPause() {

    }

    @Override
    public String[] apis() {
        return null;
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {

    }
}
