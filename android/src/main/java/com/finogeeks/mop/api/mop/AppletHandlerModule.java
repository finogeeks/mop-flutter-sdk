package com.finogeeks.mop.api.mop;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppTrace;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.lib.applet.page.view.moremenu.MoreMenuItem;
import com.finogeeks.lib.applet.page.view.moremenu.MoreMenuType;
import com.finogeeks.lib.applet.rest.model.GrayAppletVersionConfig;
import com.finogeeks.lib.applet.sdk.api.IAppletApiManager;
import com.finogeeks.lib.applet.sdk.api.IAppletHandler;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.finogeeks.mop.utils.GsonUtil;
import com.google.gson.reflect.TypeToken;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import io.flutter.plugin.common.MethodChannel;

public class AppletHandlerModule extends BaseApi {

    private Handler handler = new Handler(Looper.getMainLooper());
    private IAppletHandler.IAppletCallback phoneNumberCallback;
    private IAppletHandler mIAppletHandler = null;

    public AppletHandlerModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"registerAppletHandler", "getPhoneNumberResult"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {

        if ("getPhoneNumberResult".equals(event)) {
            FinAppTrace.d("AppletHandlerModule", "getPhoneNumberResult");
            getPhoneNumberResult(event, param, callback);
            return;
        }
        Log.d("AppletHandlerModule", "registerAppletHandler");

        MethodChannel channel = MopPluginService.getInstance().getMethodChannel();
        FinAppClient.INSTANCE.getAppletApiManager().setAppletHandler(mIAppletHandler = new IAppletHandler() {

            @Nullable
            @Override
            public List<GrayAppletVersionConfig> getGrayAppletVersionConfigs(@NotNull String s) {
                return null;
            }

            @Override
            public void shareAppMessage(@NotNull String s, @Nullable Bitmap bitmap, @NotNull IAppletCallback iAppletCallback) {
                Log.d("MopPlugin", "shareAppMessage:" + s + " bitmap:" + bitmap);
                Map<String, Object> params = new HashMap<>();
                params.put("appletInfo", GsonUtil.gson.fromJson(s, new TypeToken<Map<String, Object>>() {
                }.getType()));
                if (bitmap != null) {
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
                    byte[] data = baos.toByteArray();
                    params.put("bitmap", data);
                }
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
                            FinAppTrace.d(TAG, "getCustomMenus success : " + ret + " size : " + ret.size());
                            if (ret != null) {
                                for (Map<String, Object> map : ret) {
                                    String type = (String) map.get("type");
                                    MoreMenuType moreMenuType;
                                    if ("common".equals(type)) {
                                        moreMenuType = MoreMenuType.COMMON;
                                    } else {
                                        moreMenuType = MoreMenuType.ON_MINI_PROGRAM;
                                    }
                                    moreMenuItems.add(new MoreMenuItem((String) map.get("menuId"), (String) map.get("title"), moreMenuType));
                                }
                            }
                            latch.countDown();
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FinAppTrace.e(TAG, "getCustomMenus errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            latch.countDown();
                        }

                        @Override
                        public void notImplemented() {
                            FinAppTrace.d(TAG, "getCustomMenus notImplemented");
                            latch.countDown();
                        }
                    });
                });
                try {
                    latch.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                FinAppTrace.d(TAG, "getRegisteredMoreMenuItems moreMenuItems : " + moreMenuItems + " size : " + moreMenuItems.size());
                return moreMenuItems;
            }

            @Override
            public void onRegisteredMoreMenuItemClicked(@NotNull String appId, @NotNull String path, @NotNull String menuItemId, @Nullable String appInfo, @Nullable Bitmap bitmap, @NotNull IAppletCallback iAppletCallback) {
                Map<String, Object> params = new HashMap<>();
                params.put("appId", appId);
                params.put("path", path);
                params.put("menuId", menuItemId);
                params.put("appInfo", appInfo);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:onCustomMenuClick", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            FinAppTrace.d(TAG, "onCustomMenuClick success");
                            iAppletCallback.onSuccess(null);
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FinAppTrace.e(TAG, "onCustomMenuClick errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            iAppletCallback.onFailure();
                        }

                        @Override
                        public void notImplemented() {
                            FinAppTrace.d(TAG, "onCustomMenuClick notImplemented");
                            iAppletCallback.onFailure();
                        }
                    });
                });
            }

            @Override
            public void onNavigationBarCloseButtonClicked(@NotNull String s) {

            }

            @Override
            public boolean launchApp(@Nullable String appParameter) {
                /*Log.d("AppletHandlerModule", "getUserInfo");
                CountDownLatch latch = new CountDownLatch(1);
                final Map<String, String>[] ret = new Map[1];
                Map<String, String> params = new HashMap<String, String>();
                params.put("appParameter", appParameter);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:launchApp", params, new MethodChannel.Result() {
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
                    return null;*/
                return false;
            }

            @Override
            public void getPhoneNumber(@NotNull IAppletCallback callback) {
                Map<String, Object> params = new HashMap<>();
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:getPhoneNumber", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            FinAppTrace.d(TAG, "onCustomMenuClick success");
//                            callback.onSuccess(null);
                            phoneNumberCallback = callback;
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FinAppTrace.e(TAG, "onCustomMenuClick errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            callback.onFailure();
                        }

                        @Override
                        public void notImplemented() {
                            FinAppTrace.d(TAG, "onCustomMenuClick notImplemented");
                            callback.onFailure();
                        }
                    });
                });
            }

            @Override
            public void chooseAvatar(@NotNull IAppletCallback callback) {
                IAppletApiManager appletApiManager = FinAppClient.INSTANCE.getAppletApiManager();
                String currentId = appletApiManager.getCurrentAppletId();
                if (currentId == null || TextUtils.isEmpty(currentId)) {
                    callback.onFailure();
                    return;
                }
                appletApiManager.callInAppletProcess(
                        currentId,
                        "showChooseAvatarBottomSheet",
                        "",
                        new FinCallback<String>() {
                            @Override
                            public void onSuccess(String s) {
                                chooseAvatarChannel(s, callback, channel);
                            }

                            @Override
                            public void onError(int i, String s) {
                                callback.onFailure();
                            }

                            @Override
                            public void onProgress(int i, String s) {

                            }
                        });
            }

            @Override
            public boolean contact(@NotNull JSONObject json) {
                return false;
            }

            @Override
            public boolean feedback(@NotNull Bundle bundle) {
                return false;
            }

        });
        callback.onSuccess(null);
    }

    private void getPhoneNumberResult(String event, Map param, ICallback callback) {
        FinAppTrace.d("AppletHandlerModule", "getPhoneNumberResult,param:" + param.toString());
        callback.onSuccess(null);
        if (phoneNumberCallback != null) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("phone", param.get("phone"));
            } catch (JSONException e) {
                e.printStackTrace();
            }
            phoneNumberCallback.onSuccess(jsonObject);
        }
    }

    private void chooseAvatarChannel(String type, IAppletHandler.IAppletCallback callback, MethodChannel channel) {
        handler.post(() -> {
            String channelMethodName;
            if (TextUtils.equals(type, "album")) {
                channelMethodName = "extensionApi:chooseAvatarAlbum";
            } else if (TextUtils.equals(type, "camera")) {
                channelMethodName = "extensionApi:chooseAvatarPhoto";
            } else {
                return;
            }
            channel.invokeMethod(channelMethodName, null, new MethodChannel.Result() {
                @Override
                public void success(@androidx.annotation.Nullable Object result) {
                    moveCurrentAppletToFront();
                    if (result != null) {
                        try {
                            Map<String, String> resultMap = (Map<String, String>) result;
                            JSONObject resultJson = new JSONObject();
                            String avatarUrl = resultMap.get("avatarUrl");
                            resultJson.put("avatarUrl", avatarUrl);
                            callback.onSuccess(resultJson);
                        } catch (Exception e) {
                            e.printStackTrace();
                            callback.onFailure();
                        }
                    } else {
                        callback.onFailure();
                    }
                }

                @Override
                public void error(String errorCode, @androidx.annotation.Nullable String errorMessage, @androidx.annotation.Nullable Object errorDetails) {
                    moveCurrentAppletToFront();
                    callback.onFailure();
                }

                @Override
                public void notImplemented() {

                }
            });
        });
    }

    private void moveCurrentAppletToFront() {
        try {
            String currentAppletId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
            if (currentAppletId == null || TextUtils.isEmpty(currentAppletId)) {
                return;
            }
            String activityName = FinAppClient.INSTANCE.getAppletApiManager().getAppletActivityName(currentAppletId);
            if (activityName == null) {
                return;
            }
            if (activityName.contains("@")) {
                activityName = activityName.substring(0, activityName.indexOf("@"));
            }
            Intent intent = new Intent(getContext(), Class.forName(activityName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            PendingIntent pendingIntent = PendingIntent.getActivities(getContext(), 0, new Intent[]{intent}, 0);
            pendingIntent.send();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
