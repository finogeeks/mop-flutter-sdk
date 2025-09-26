package com.finogeeks.mop.service;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.rest.model.GrayAppletVersionConfig;
import com.finogeeks.mop.MopEventStream;
import com.finogeeks.mop.api.ApisManager;

import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class MopPluginService {
    private final static String TAG = MopPluginService.class.getSimpleName();
    private static volatile MopPluginService _instance = null;

    private ApisManager apisManager;
    private MopEventStream mopEventStream;


    private Context mContext;
    private Activity mActivity;
    private MethodChannel mMethodChannel;

    private Map<String, Object> grayAppletVersionConfigs;

    MopPluginService() {
    }

    public static MopPluginService getInstance() {
        if (_instance == null) {
            synchronized (MopPluginService.class) {
                if (_instance == null) {
                    _instance = new MopPluginService();
                }
            }
        }
        return _instance;
    }

    public ApisManager getApisManager() {
        return this.apisManager;
    }

    public MopEventStream getMopEventStream() {
        return this.mopEventStream;
    }


    public void setGrayAppletVersionConfigs(Map<String, Object> grayAppletVersionConfigs) {
        this.grayAppletVersionConfigs = grayAppletVersionConfigs;
    }

    @Nullable
    public List<GrayAppletVersionConfig> getGrayAppletVersionConfigsById(String appId) {
        try {
            if (grayAppletVersionConfigs != null) {
                // 优先取对应appId的配置
                Map<String, Object> curConfigs = (Map<String, Object>) grayAppletVersionConfigs.get(appId);
                if (curConfigs != null) {
                    return mapToList(curConfigs);
                } else {
                    // 如果没有对应appId的配置，则取Other的配置
                    Map<String, Object> other = (Map<String, Object>) grayAppletVersionConfigs.get("Other");
                    return mapToList(other);
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private List<GrayAppletVersionConfig> mapToList(@Nullable Map<String, Object> result) {
        List<GrayAppletVersionConfig> list = new ArrayList<>();
        if (result != null && !result.isEmpty()) {
            for (Map.Entry<String, Object> entry : result.entrySet()) {
                list.add(new GrayAppletVersionConfig(entry.getKey(), entry.getValue()));
            }
            return list;
        }
        return null;
    }

    public void initialize(Activity activity, MopEventStream mopEventStream, MethodChannel methodChannel) {
        this.mopEventStream = mopEventStream;
        this.mContext = activity.getApplicationContext();
        this.apisManager = new ApisManager(activity);
        this.mActivity = activity;
        this.mMethodChannel = methodChannel;
    }

    public Context getContext() {
        return mContext;
    }

    public Activity getActivity() {
        return mActivity;
    }

    public MethodChannel getMethodChannel() {
        return mMethodChannel;
    }
}
