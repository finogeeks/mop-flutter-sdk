package com.finogeeks.mop.api.mop;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.BuildConfig;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.client.FinStoreConfig;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BaseModule extends BaseApi {
    private final static String TAG = BaseModule.class.getSimpleName();

    public BaseModule(Context context) {
        super(context);
    }

    @Override
    public void onCreate() {
        super.onCreate();

    }

    @Override
    public String[] apis() {
        return new String[]{"initialize"};
    }

    @Override
    public void invoke(String event, Map param, final ICallback callback) {

        if (FinAppClient.INSTANCE.isFinAppProcess(super.getContext())) {
            // 小程序进程不执行任何初始化操作
            return;
        }
        String appkey = String.valueOf(param.get("appkey"));
        String secret = String.valueOf(param.get("secret"));
        String apiServer = "https://api.finclip.com";
        String apiPrefix = "/api/v1/mop/";
        String cryptType = (String) param.get("cryptType");
        if (cryptType == null || cryptType.isEmpty()) {
            cryptType = "MD5";
        }
        if (param.get("apiServer") != null) {
            apiServer = String.valueOf(param.get("apiServer"));
        }
        if (param.get("apiPrefix") != null) {
            apiPrefix = String.valueOf(param.get("apiPrefix"));
            if (!apiPrefix.endsWith("/")) {
                apiPrefix = apiPrefix + "/";
            }
        }
        Boolean disablePermission = (Boolean) param.get("disablePermission");
        if (disablePermission == null) {
            disablePermission = false;
        }
        String userId = "";
        if (param.get("userId") != null) {
            userId = (String) param.get("userId");
        }

        Boolean encryptServerData = (Boolean) param.get("encryptServerData");
        if (encryptServerData == null) encryptServerData = false;
        Boolean debug = (Boolean) param.get("debug");
        if (debug == null) debug = false;
        Boolean bindAppletWithMainProcess = (Boolean) param.get("bindAppletWithMainProcess");
        if (bindAppletWithMainProcess == null) bindAppletWithMainProcess = false;

        String customWebViewUserAgent = (String) param.get("customWebViewUserAgent");
        Integer appletIntervalUpdateLimit = (Integer) param.get("appletIntervalUpdateLimit");
        Integer maxRunningApplet = (Integer) param.get("maxRunningApplet");
        Gson gson = new Gson();
        List<FinStoreConfig> finStoreConfigs = null;
        if (param.get("finStoreConfigs") != null) {
            finStoreConfigs = gson.fromJson(gson.toJson(param.get("finStoreConfigs")), new TypeToken<List<FinStoreConfig>>() {
            }.getType());
        }
        FinAppConfig.UIConfig uiConfig = null;
        if (param.get("uiConfig") != null) {
            uiConfig = gson.fromJson(gson.toJson(param.get("uiConfig")), FinAppConfig.UIConfig.class);
        }


        FinAppConfig.Builder builder = new FinAppConfig.Builder()
                .setSdkKey(appkey)
                .setSdkSecret(secret)
                .setApiUrl(apiServer)
                .setApiPrefix(apiPrefix)
                .setEncryptionType(cryptType)
                .setEncryptServerData(encryptServerData)
                .setUserId(userId)
                .setDebugMode(debug)
                .setDisableRequestPermissions(disablePermission)
                .setBindAppletWithMainProcess(bindAppletWithMainProcess);

        if (customWebViewUserAgent != null)
            builder.setCustomWebViewUserAgent(customWebViewUserAgent);
        if (appletIntervalUpdateLimit != null)
            builder.setAppletIntervalUpdateLimit(appletIntervalUpdateLimit);
        if (maxRunningApplet != null) builder.setMaxRunningApplet(maxRunningApplet);
        if (finStoreConfigs != null) builder.setFinStoreConfigs(finStoreConfigs);
        if (uiConfig != null) builder.setUiConfig(uiConfig);

        FinAppConfig config = builder.build();
        Log.d(TAG, "config:" + gson.toJson(config));

        final Application application = MopPluginService.getInstance().getActivity().getApplication();
        // SDK初始化结果回调，用于接收SDK初始化状态
        FinCallback<Object> cb = new FinCallback<Object>() {
            @Override
            public void onSuccess(Object result) {
                // SDK初始化成功
                callback.onSuccess(null);
            }

            @Override
            public void onError(int code, String error) {
                // SDK初始化失败
                callback.onFail(null);
//                Toast.makeText(MopPluginService.getInstance().getContext(), "SDK初始化失败", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onProgress(int status, String error) {

            }
        };
        FinAppClient.INSTANCE.init(application, config, cb);
    }
}