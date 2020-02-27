package com.finogeeks.mop.service;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import com.finogeeks.mop.MopEventStream;
import com.finogeeks.mop.api.ApisManager;

public class MopPluginService {
    private final static String TAG = MopPluginService.class.getSimpleName();
    private static volatile MopPluginService _instance = null;

    private ApisManager apisManager;
    private MopEventStream mopEventStream;


    private Context mContext;
    private Activity mActivity;

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

    public ApisManager getApisManager() { return this.apisManager;}
    public MopEventStream getMopEventStream() {return this.mopEventStream;}
    public void initialize(Activity activity, MopEventStream mopEventStream) {
        this.mopEventStream = mopEventStream;
        this.mContext = activity.getApplicationContext();
        this.apisManager = new ApisManager(activity);
        this.mActivity = activity;


    }
    public Context getContext() {
        return mContext;
    }
    public Activity getActivity() {
        return mActivity;
    }
}
