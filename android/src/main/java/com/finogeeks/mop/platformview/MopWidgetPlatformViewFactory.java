package com.finogeeks.mop.platformview;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Unified PlatformView factory for MOP.
 * Create different native views based on external "viewType" passed from Dart.
 */
public class MopWidgetPlatformViewFactory extends PlatformViewFactory {

    @Nullable
    private Activity activity;
    private static final String TAG = "MOP-PlatformView";

    public MopWidgetPlatformViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    public void setActivity(@Nullable Activity activity) {
        this.activity = activity;
        Log.d(TAG, "Factory.setActivity: " + (activity == null ? "null" : activity.getClass().getName()));
    }

    @Override
    @NonNull
    @SuppressWarnings("unchecked")
    public PlatformView create(@NonNull Context context, int viewId, Object args) {
        String externalViewType = "default";
        Map<String, Object> creationParams = null;
        if (args instanceof Map) {
            Map<String, Object> map = (Map<String, Object>) args;
            Object vt = map.get("viewType");
            if (vt instanceof String) externalViewType = (String) vt;
            Object p = map.get("params");
            if (p instanceof Map) creationParams = (Map<String, Object>) p;
        }
        Log.d(TAG, "Factory.create: viewId=" + viewId
                + ", externalViewType=" + externalViewType
                + ", params=" + (creationParams == null ? "null" : creationParams.toString())
                + ", activity=" + (activity == null ? "null" : activity.getClass().getName()));
        return new MopWidgetPlatformView(context, viewId, externalViewType, creationParams, activity);
    }


}
