package com.finogeeks.mop.api.mop;

import android.content.Context;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.db.entity.FinApplet;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.HashMap;
import java.util.Map;


public class AppletManageModule extends BaseApi {

    public AppletManageModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"currentApplet", "closeAllApplets", "clearApplets"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if (event.equals("currentApplet")) {
            String appId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
            if (appId != null) {
                FinApplet applet = FinAppClient.INSTANCE.getAppletApiManager().getUsedApplet(appId);
                if (applet != null) {
                    Map<String, Object> res = new HashMap<>();
                    res.put("appId", applet.getId());
                    res.put("name", applet.getName());
                    res.put("icon", applet.getIcon());
                    res.put("description", applet.getDescription());
                    res.put("version", applet.getVersion());
                    res.put("thumbnail", applet.getThumbnail());
                    callback.onSuccess(res);
                } else {
                    callback.onSuccess(null);
                }
            } else {
                callback.onSuccess(null);
            }
        } else if (event.equals("closeAllApplets")) {
            FinAppClient.INSTANCE.finishAllRunningApplets();
            callback.onSuccess(null);
        } else if (event.equals("clearApplets")) {
            FinAppClient.INSTANCE.getAppletApiManager().clearApplets();
            callback.onSuccess(null);
        }
    }
}
