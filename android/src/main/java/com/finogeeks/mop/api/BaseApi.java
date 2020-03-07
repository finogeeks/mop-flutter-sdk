package com.finogeeks.mop.api;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

public abstract class BaseApi extends AbsApi {


    protected static final String TAG = "InnerApi";

    protected static final Handler HANDLER = new Handler(Looper.getMainLooper());

    private Context mContext;

    public BaseApi(Context context) {
        mContext = context;
    }

    public Context getContext() {
        return mContext;
    }
}
