package com.finogeeks.mop.api.mop;


import android.content.Context;

import com.finogeeks.lib.applet.BuildConfig;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.Map;

public class VersionModule extends BaseApi {

    public VersionModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"sdkVersion"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        callback.onSuccess(BuildConfig.VERSION_NAME);
    }
}
