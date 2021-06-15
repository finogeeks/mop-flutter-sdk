package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.model.StartAppletDecryptRequest;
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
        return new String[]{"openApplet", "scanOpenApplet"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("openApplet".equals(event)) {
            openApplet(param, callback);
        } else if ("scanOpenApplet".equals(event)) {
            scanOpenApplet(param, callback);
        }
    }

    private void openApplet(Map param, ICallback callback) {
        if (param.get("appId") == null) {
            callback.onFail(new HashMap() {
                {
                    put("info", "appId不能为空");
                }
            });
            return;
        }
        Log.d("MopPlugin", "openApplet:params:" + param);
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
            FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, params);
        }
//        String apiServer = (String) param.get("apiServer");
//        String apiPrefix = (String) param.get("apiPrefix");
//        if (apiServer == null || apiServer.isEmpty() || apiPrefix == null || apiPrefix.isEmpty()) {
//            if (params == null) {
//                if (sequence == null) {
//                    FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId);
//                } else {
//                    FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, sequence, null);
//                }
//            } else {
//                FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, params);
//            }
//        } else {
//            String fingerprint = (String) param.get("fingerprint");
//            if (fingerprint == null) {
//                fingerprint = "";
//            }
//            String cryptType = (String) param.get("cryptType");
//            if (cryptType == null || cryptType.isEmpty()) {
//                cryptType = FinAppConfig.ENCRYPTION_TYPE_MD5;
//            }
//            FinAppletStoreConfig finAppletStoreConfig = new FinAppletStoreConfig(apiServer, apiPrefix, fingerprint, cryptType);
//            FinAppInfo.StartParams startParams = null;
//            if (params != null) {
//                String pageURL = params.get("path");
//                String launchParams = params.get("query");
//                String scene = params.get("scene");
//                startParams = new FinAppInfo.StartParams(pageURL, launchParams, scene);
//            }
//            Log.d("MopPlugin", "openApplet:finAppletStoreConfig:" + finAppletStoreConfig.toString());
//            Log.d("MopPlugin", "openApplet:appId:" + appId);
//            Log.d("MopPlugin", "openApplet:sequence:" + sequence);
//            Log.d("MopPlugin", "openApplet:startParams:" + startParams);
//            FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, finAppletStoreConfig, appId, sequence, startParams);
//        }
        callback.onSuccess(new HashMap());
    }

    private void scanOpenApplet(Map param, ICallback callback) {
        String info = String.valueOf(param.get("info"));
        if (TextUtils.isEmpty(info)) {
            callback.onFail(new HashMap() {
                {
                    put("info", "info不能为" + info);
                }
            });
            return;
        }
        FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, new StartAppletDecryptRequest(info));
        callback.onSuccess(new HashMap());
    }
}
