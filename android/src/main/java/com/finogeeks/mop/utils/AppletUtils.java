package com.finogeeks.mop.utils;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.mop.interfaces.ICallback;

public class AppletUtils {
    public static void moveCurrentAppletToFront(Context context, ICallback<Object> callback) {
        try {
            String currentAppletId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
            if (currentAppletId == null || TextUtils.isEmpty(currentAppletId)) {
                if (callback != null) {
                    callback.onFail(null);
                }
                return;
            }
            String activityName = FinAppClient.INSTANCE.getAppletApiManager().getAppletActivityName(currentAppletId);
            if (activityName == null) {
                if (callback != null) {
                    callback.onFail(null);
                }
                return;
            }
            if (activityName.contains("@")) {
                activityName = activityName.substring(0, activityName.indexOf("@"));
            }
            Intent intent = new Intent(context, Class.forName(activityName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            PendingIntent pendingIntent = PendingIntent.getActivities(context, 0, new Intent[]{intent}, 0);
            pendingIntent.send();
            callback.onSuccess(null);
        } catch (Exception e) {
            e.printStackTrace();
            if (callback != null) {
                callback.onFail(null);
            }
        }
    }
}
