package com.finogeeks.mop.utils;

import android.content.Context;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppProcessClient;
import com.finogeeks.lib.applet.main.FinAppHomeActivity;
import com.finogeeks.mop.interfaces.ICallback;

public class AppletUtils {
    public static void moveCurrentAppletToFront(Context context, ICallback<Object> callback) {
        try {
            if (FinAppClient.INSTANCE.isFinAppProcess(context)) {
                FinAppHomeActivity activity = (FinAppHomeActivity) FinAppProcessClient.INSTANCE.getAppletProcessActivity();
                if (activity != null) {
                    activity.moveTaskToFront();
                }
            } else {
                String currentAppletId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
                if (currentAppletId != null) {
                    FinAppClient.INSTANCE.getAppletApiManager().moveTaskToFront(currentAppletId);
                }
            }
            if (callback != null) {
                callback.onSuccess(null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (callback != null) {
                callback.onFail(null);
            }
        }
    }
}
