package com.finogeeks.mop.interfaces;

import android.os.Handler;
import android.os.Looper;

import com.finogeeks.mop.service.MopPluginService;


public class FlutterInterface {
    private static final String TAG = FlutterInterface.class.getSimpleName();

    private Handler mHandler = new Handler(Looper.getMainLooper());

    public void invokeHandler(final Event event) {

        mHandler.post(new Runnable() {
            @Override
            public void run() {
                MopPluginService.getInstance().getApisManager().invoke(event);
            }
        });
    }
}