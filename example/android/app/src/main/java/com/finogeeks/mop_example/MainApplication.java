package com.finogeeks.mop_example;

import android.app.AlertDialog;
import android.app.Application;
import android.app.Dialog;
import android.content.Context;
// import android.support.annotation.NonNull;
import androidx.annotation.NonNull;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppProcessClient;
import com.finogeeks.lib.applet.sdk.api.IAppletProcessApiManager;
import com.finogeeks.lib.applet.sdk.api.IAppletProcessHandler;

public class MainApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        initProcessHandler();
    }

    private void initProcessHandler() {
        if (!FinAppClient.INSTANCE.isFinAppProcess(this)) {
            return;
        }

        // FinAppProcessClient.INSTANCE.getAppletProcessApiManager().setAppletProcessHandler(new IAppletProcessHandler(){
        //     @Override
        //     public boolean onNavigationBarMoreButtonClicked(@NonNull Context context, @NonNull String appId) {
        //         // 在这里弹出自定义的更多视图
        //         new AlertDialog.Builder(context)
        //                 .setTitle("更多视图")
        //                 .setMessage(appId)
        //                 .setPositiveButton("菜单", null)
        //                 .setNegativeButton("取消", null)
        //                 .show();

        //         // 返回true表示要自行处理更多视图；返回false表示使用默认的更多视图
        //         return true;
        //     }
        // });
    }
}