package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.HashMap;
import java.util.Map;

public class AppletModule extends BaseApi {
    private final static String TAG = AppletModule.class.getSimpleName();
    private Context mContext;

    public AppletModule(Context context) {
        super(context);
        mContext = context;
    }

    @Override
    public void onCreate() {
        super.onCreate();

    }

    @Override
    public String[] apis() {
        return new String[]{"openApplet"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if (param.get("appId") == null) {
            callback.onFail(new HashMap() {
                {
                    put("info", "appId不能为空");
                }
            });
            return;
        }
        String appId = String.valueOf(param.get("appId"));
        Integer sequence = (Integer) param.get("sequence");
        Map<String, String> params = (Map) param.get("params");
        if (params == null) {
            if (sequence == null) {
                FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId);
            } else {
                FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, sequence, null);
            }
        } else {
            Log.d("MopPlugin", "openApplet:params:" + param);
            FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, params);
        }
        callback.onSuccess(new HashMap());
    }
}
