package com.finogeeks.mop.api.mop;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.google.gson.Gson;

import java.util.Map;

public class InitSDKModule extends BaseApi {

    private final static String TAG = "InitSDKModule";

    public InitSDKModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"initSDK"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if (FinAppClient.INSTANCE.isFinAppProcess(super.getContext())) {
            // 小程序进程不执行任何初始化操作
            return;
        }

        Log.d(TAG, "param:" + param);
        if (param.get("config") == null) {
            callback.onFail("config不能为空");
            return;
        }

        Gson gson = new Gson();
        FinAppConfig config = gson.fromJson(gson.toJson(param.get("config")), FinAppConfig.class);

        FinAppConfig.UIConfig uiConfig = null;
        if (param.containsKey("uiConfig")) {
            uiConfig = gson.fromJson(gson.toJson(param.get("uiConfig")), FinAppConfig.UIConfig.class);
        }


//        FinAppConfig config = builder.build();
//        Log.d(TAG, "config:" + gson.toJson(config));

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
            }

            @Override
            public void onProgress(int status, String error) {

            }
        };
        FinAppClient.INSTANCE.init(application, config, cb);
    }
}
