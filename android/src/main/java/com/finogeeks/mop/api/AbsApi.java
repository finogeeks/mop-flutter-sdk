package com.finogeeks.mop.api;

import android.content.Intent;

import com.finogeeks.mop.interfaces.IApi;
import com.finogeeks.mop.interfaces.ICallback;

public abstract class AbsApi implements IApi {

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
    public void onNewIntent(Intent intent) {

    }
    @Override
    public void onResume() {

    }
    @Override
    public void onPause() {

    }
}
