package com.finogeeks.mop.api.mop;

import android.content.Context;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.db.entity.FinApplet;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.utils.GsonUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppletCacheModule extends BaseApi {
    private final static String TAG = AppletCacheModule.class.getSimpleName();

    public AppletCacheModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"getUsedApplets"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("getUsedApplets".equals(event)) {
            getUsedApplets(callback);
        }
    }

    private void getUsedApplets(ICallback callback) {
        try {
            List<FinApplet> usedApplets = FinAppClient.INSTANCE.getAppletApiManager().getUsedApplets();
            List<Map<String, Object>> list = new ArrayList<>();
            if (usedApplets != null) {
                for (FinApplet applet : usedApplets) {
                    HashMap<String, Object> appletInfo = new HashMap<>();
                    appletInfo.put("appId",applet.getId());
                    appletInfo.put("appName",applet.getName());
                    appletInfo.put("apiServer",applet.getApiUrl());
                    appletInfo.put("frameworkVersion",applet.getFrameworkVersion());
                    appletInfo.put("logo",applet.getIcon());
                    appletInfo.put("version",applet.getVersion());
                    list.add(appletInfo);
                }
            }
            Map<String, Object> result = new HashMap<>();
            result.put("list", list);
            callback.onSuccess(result);
        } catch (Exception e) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", e.getMessage());
            }});
        }
    }
}