package com.finogeeks.mop.api.mop;

import android.content.Context;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.model.FinApplet;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

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
            List<FinApplet> usedApplets = FinAppClient.getAppletApiManager().getUsedApplets();

            List<Map<String, Object>> list = new ArrayList<>();
            if (usedApplets != null) {
                for (FinApplet applet : usedApplets) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("appId", applet.getAppId());
                    map.put("name", applet.getName());
                    map.put("icon", applet.getIcon());
                    map.put("description", applet.getDescription());
                    map.put("version", applet.getVersion());
                    map.put("thumbnail", applet.getThumbnail());
                    list.add(map);
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("data", list);
            callback.onSuccess(result);
        } catch (Exception e) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", e.getMessage());
            }});
        }
    }
}