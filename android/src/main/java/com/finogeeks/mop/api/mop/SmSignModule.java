package com.finogeeks.mop.api.mop;

import android.content.Context;

import com.finogeeks.finclip.sdkcore.manager.FinClipSDKCoreManager;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.db.entity.FinApplet;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.HashMap;
import java.util.Map;

public class SmSignModule extends BaseApi {

    public SmSignModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"smsign"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        String text = (String) param.get("plainText");
        String result = new FinClipSDKCoreManager.Builder().build().messageDigestBySM(text);
        Map<String, Object> res = new HashMap<>();
        res.put("data", result);
        callback.onSuccess(res);
    }

}
