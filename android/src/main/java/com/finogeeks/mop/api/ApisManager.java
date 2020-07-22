package com.finogeeks.mop.api;

import android.app.Activity;
import android.text.TextUtils;

import com.finogeeks.mop.api.mop.AppletHandlerModule;
import com.finogeeks.mop.api.mop.AppletManageModule;
import com.finogeeks.mop.api.mop.AppletModule;
import com.finogeeks.mop.api.mop.BaseModule;
import com.finogeeks.mop.api.mop.ExtensionApiModule;
import com.finogeeks.mop.api.mop.VersionModule;
import com.finogeeks.mop.interfaces.Event;
import com.finogeeks.mop.interfaces.IApi;

import java.util.HashMap;
import java.util.Map;

public class ApisManager {


    private final static String TAG = ApisManager.class.getSimpleName();

    public static final int SUCCESS = 0x10;
    public static final int FAIL = 0x11;
    public static final int CANCEL = 0x12;
    public static final int PENDING = 0x13;

    private final IApi EMPTY_API = new EmptyApi();
    private final Map<String, IApi> APIS = new HashMap<>();
    private Activity mActivity;

    public ApisManager(Activity activity) {
        mActivity = activity;
        initSdkApi(activity);
    }

    /**
     * api功能调用
     *
     * @param event 封装了api名称，参数及回调函数id的对象
     */
    public IApi getApiInstance(Event event) {
        IApi api = APIS.get(event.getName());
        if (api != null) {
            return api;
        }
        return null;

    }

    /**
     * api功能调用
     *
     * @param event 封装了api名称，参数及回调函数id的对象
     */
    public void invoke(Event event) {
        IApi api = APIS.get(event.getName());
        if (api != null) {
            api.invoke(event.getName(), event.getParam(), event.getCallback());
            return;
        }

    }

    private void initSdkApi(Activity activity) {
        add(new BaseModule(activity));
        add(new AppletModule(activity));
        add(new AppletManageModule(activity));
        add(new AppletHandlerModule(activity));
        add(new ExtensionApiModule(activity));
        add(new VersionModule(activity));
    }

    private void add(IApi api) {
        if (api != null && api.apis() != null && api.apis().length > 0) {
            String[] apiNames = api.apis();
            for (String name : apiNames) {
                if (!TextUtils.isEmpty(name)) {
                    APIS.put(name, api);
                }
            }
        }
    }

}
