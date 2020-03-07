package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.widget.Toast;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;

import java.util.HashMap;
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
        String apiServer = "https://mp.finogeeks.com";
        String apiPrefix = "/api/v1/mop/";
        if (param.get("apiServer") != null) {
            apiServer = String.valueOf(param.get("apiServer"));
        }
        if (param.get("apiPrefix") != null) {
            apiPrefix = String.valueOf(param.get("apiPrefix"));
            if (!apiPrefix.endsWith("/")) {
                apiPrefix = apiPrefix + "/";
            }
        }
        FinAppConfig config = new FinAppConfig.Builder()
                .setAppKey(appkey)
                .setAppSecret(secret)
                .setApiUrl(apiServer)
                .setApiPrefix(apiPrefix)
                .setGlideWithJWT(false)
                .build();
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
        FinAppClient.INSTANCE.init(MopPluginService.getInstance().getActivity().getApplication(), config, cb);



    }
}
