package com.finogeeks.mop.impls;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppInfo;
import com.finogeeks.lib.applet.modules.userprofile.IUserProfileHandler;
import com.finogeeks.mop.service.MopPluginService;

import java.util.Map;

import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel;

public class MyUserProfileHandler implements IUserProfileHandler {
    private static final String TAG = "MyUserProfileHandler";

    private Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public void getUserProfileWithAppletInfo(@NotNull Context context, @NotNull FinAppInfo finAppInfo, @NotNull UserProfileCallback callback) {
        MethodChannel channel = MopPluginService.getInstance().getMethodChannel();
        Log.d(TAG, "getUserProfileWithAppletInfo:");
        Log.d(TAG, "channel:" + (channel != null ? "存在" : "不存在"));
        new Handler(Looper.getMainLooper()).post(() -> {
            channel.invokeMethod("extensionApi:getUserProfile", null, new MethodChannel.Result() {
                @Override
                public void success(Object mapResult) {
                    JSONObject result = null;
                    try {
                        result = new JSONObject((Map) mapResult);
                    } catch (Exception e) {

                    }

                    if (result == null) {
                        callback.onError(null);
                    } else {
                        callback.onSuccess(result);
                    }
                }

                @Override
                public void error(String errorCode, String errorMessage, Object errorDetails) {
                    callback.onError(null);
                }

                @Override
                public void notImplemented() {
                    callback.onError(null);
                }
            });
        });
    }
}
