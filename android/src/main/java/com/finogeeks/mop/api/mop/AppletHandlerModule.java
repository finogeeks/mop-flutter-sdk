package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.page.view.moremenu.MoreMenuItem;
import com.finogeeks.lib.applet.sdk.api.IAppletHandler;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.finogeeks.mop.utils.GsonUtil;
import com.google.gson.reflect.TypeToken;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import io.flutter.plugin.common.MethodChannel;

public class AppletHandlerModule extends BaseApi {

    private Handler handler = new Handler(Looper.getMainLooper());

    public AppletHandlerModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"registerAppletHandler"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        Log.d("AppletHandlerModule", "registerAppletHandler");
        MethodChannel channel = MopPluginService.getInstance().getMethodChannel();
        FinAppClient.INSTANCE.getAppletApiManager().setAppletHandler(new IAppletHandler() {
            @Override
            public void shareAppMessage(@NotNull String s, @Nullable Bitmap bitmap, @NotNull IAppletCallback iAppletCallback) {
                Log.d("MopPlugin", "shareAppMessage:" + s);
                Map<String, Object> params = new HashMap<>();
                params.put("appletInfo", GsonUtil.gson.fromJson(s, new TypeToken<Map<String, Object>>() {
                }.getType()));
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:forwardApplet", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            iAppletCallback.onSuccess(null);
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            iAppletCallback.onFailure();
                        }

                        @Override
                        public void notImplemented() {
                            iAppletCallback.onFailure();
                        }
                    });
                });
            }

            @Nullable
            @Override
            public Map<String, String> getUserInfo() {
                Log.d("AppletHandlerModule", "getUserInfo");
                CountDownLatch latch = new CountDownLatch(1);
                final Map<String, String>[] ret = new Map[1];
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:getUserInfo", null, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            ret[0] = (Map<String, String>) result;
                            latch.countDown();
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            latch.countDown();
                        }

                        @Override
                        public void notImplemented() {
                            latch.countDown();
                        }
                    });
                });
                try {
                    latch.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                if (ret[0].size() > 0)
                    return ret[0];
                else
                    return null;
            }

            @Nullable
            @Override
            public List<MoreMenuItem> getRegisteredMoreMenuItems(@NotNull String s) {
                CountDownLatch latch = new CountDownLatch(1);
                List<MoreMenuItem> moreMenuItems = new ArrayList<>();
                Map<String, Object> params = new HashMap<>();
                params.put("appId", s);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:getCustomMenus", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            List<Map<String, Object>> ret = (List<Map<String, Object>>) result;
                            if (ret != null) {
                                for (Map<String, Object> map : ret) {
                                    moreMenuItems.add(new MoreMenuItem((Integer) map.get("menuId"), 0, (String) map.get("title"), true));
                                }
                            }
                            latch.countDown();
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            latch.countDown();
                        }

                        @Override
                        public void notImplemented() {
                            latch.countDown();
                        }
                    });
                });
                try {
                    latch.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                return moreMenuItems;
            }

            @Override
            public void onRegisteredMoreMenuItemClicked(@NotNull String s, int i) {
                Map<String, Object> params = new HashMap<>();
                params.put("appId", s);
                params.put("menuId", i);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:onCustomMenuClick", params);
                });
            }
        });
        callback.onSuccess(null);
    }
}
