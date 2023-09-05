package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.finogeeks.lib.applet.client.FinAppProcessClient;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.modules.log.FLog;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.lib.applet.page.view.moremenu.MoreMenuItem;
import com.finogeeks.lib.applet.page.view.moremenu.MoreMenuType;
import com.finogeeks.lib.applet.rest.model.GrayAppletVersionConfig;
import com.finogeeks.lib.applet.sdk.api.IAppletApiManager;
import com.finogeeks.lib.applet.sdk.api.IAppletHandler;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.finogeeks.mop.utils.AppletUtils;
import com.finogeeks.mop.utils.GsonUtil;
import com.finogeeks.mop.impls.MyUserProfileHandler;
import com.google.gson.reflect.TypeToken;
import com.finogeeks.lib.applet.sdk.api.IAppletLifecycleCallback;


import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
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
            FLog.d("AppletHandlerModule", "getPhoneNumberResult");
            getPhoneNumberResult(event, param, callback);
            return;
        }
        Log.d("AppletHandlerModule", "registerAppletHandler");

        MethodChannel channel = MopPluginService.getInstance().getMethodChannel();
        // getUserProfile的内置实现
        FinAppClient.INSTANCE.getFinAppConfig().setGetUserProfileHandlerClass(MyUserProfileHandler.class.getName());

        FinAppClient.INSTANCE.getAppletApiManager().setAppletLifecycleCallback(new IAppletLifecycleCallback() {

            @Override
            public void onCreate(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onCreate : " + appId);
            }

            @Override
            public void onInitComplete(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onInitComplete : " + appId);
                Map<String, Object> params = new HashMap<>();
                params.put("appId", appId);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:appletDidOpen", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                        }

                        @Override
                        public void notImplemented() {
                        }
                    });
                });
            }

            @Override
            public void onStart(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onStart : " + appId);
            }

            @Override
            public void onResume(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onResume : " + appId);
            }

            @Override
            public void onPause(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onPause : " + appId);
            }

            @Override
            public void onStop(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onStop : " + appId);
            }

            @Override
            public void onDestroy(@NotNull String appId) {
                Log.d(TAG, "IAppletLifecycleCallback onDestroy : " + appId);
            }

            @Override
            public void onFailure(@NotNull String appId, String errMsg) {
                Log.d(TAG, "IAppletLifecycleCallback onFailure : " + appId);
            }
        });

        FinAppClient.INSTANCE.getAppletApiManager().setAppletHandler(mIAppletHandler = new IAppletHandler() {

            @Nullable
            @Override
            public Map<String, String> getWebViewCookie(@NonNull String s) {
                return null;
            }

            @Override
            public void getJSSDKConfig(@NonNull JSONObject jsonObject, @NonNull IAppletCallback iAppletCallback) {

            }

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
            @SuppressWarnings("unchecked")
            public List<MoreMenuItem> getRegisteredMoreMenuItems(@NotNull String s) {
                CountDownLatch latch = new CountDownLatch(1);
                List<MoreMenuItem> moreMenuItems = new ArrayList<>();
                Map<String, Object> params = new HashMap<>();
                params.put("appId", s);
                handler.post(() -> {
                    channel.invokeMethod("extensionApi:getCustomMenus", params, new MethodChannel.Result() {
                        @Override
                        public void success(Object result) {
                            if (result instanceof List) {
                                List<Map<String, Object>> ret = (List<Map<String, Object>>) result;
                                for (Map<String, Object> map : ret) {
                                    String type = (String) map.get("type");
                                    MoreMenuType moreMenuType;
                                    if ("common".equals(type)) {
                                        moreMenuType = MoreMenuType.COMMON;
                                    } else {
                                        moreMenuType = MoreMenuType.ON_MINI_PROGRAM;
                                    }
                                    String menuId = (String) map.get("menuId");
                                    if (menuId == null) {
                                        menuId = "";
                                    }
                                    String title = (String) map.get("title");
                                    if (title == null) {
                                        title = "";
                                    }
                                    String image = (String) map.get("image");
                                    if (image == null) {
                                        image = "";
                                    }
                                    String darkImage = (String) map.get("darkImage");
                                    if (darkImage == null) {
                                        darkImage = "";
                                    }
                                    moreMenuItems.add(
                                            new MoreMenuItem(
                                                    menuId,
                                                    title,
                                                    image,
                                                    -1,
                                                    darkImage,
                                                    moreMenuType,
                                                    true
                                            )
                                    );
                                }
                            }
                            latch.countDown();
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FLog.e(TAG, "getCustomMenus errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            latch.countDown();
                        }

                        @Override
                        public void notImplemented() {
                            FLog.d(TAG, "getCustomMenus notImplemented");
                            latch.countDown();
                        }
                    });
                });
                try {
                    latch.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                FLog.d(TAG, "getRegisteredMoreMenuItems moreMenuItems : " + moreMenuItems + " size : " + moreMenuItems.size());
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
                            FLog.d(TAG, "onCustomMenuClick success");
                            iAppletCallback.onSuccess(null);
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FLog.e(TAG, "onCustomMenuClick errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            iAppletCallback.onFailure();
                        }

                        @Override
                        public void notImplemented() {
                            FLog.d(TAG, "onCustomMenuClick notImplemented");
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
                            FLog.d(TAG, "onCustomMenuClick success");
//                            callback.onSuccess(null);
                            phoneNumberCallback = callback;
                        }

                        @Override
                        public void error(String errorCode, String errorMessage, Object errorDetails) {
                            FLog.e(TAG, "onCustomMenuClick errorCode : " + errorCode + " errorMessage : " + errorMessage);
                            callback.onFailure();
                        }

                        @Override
                        public void notImplemented() {
                            FLog.d(TAG, "onCustomMenuClick notImplemented");
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
        FLog.d("AppletHandlerModule", "getPhoneNumberResult,param:" + param.toString());
        callback.onSuccess(null);
        if (phoneNumberCallback != null) {
            try {
                JSONObject jsonObject = new JSONObject(param);
                phoneNumberCallback.onSuccess(jsonObject);
            } catch (Exception e) {
                e.printStackTrace();
                phoneNumberCallback.onFailure();
            }
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
                    AppletUtils.moveCurrentAppletToFront(getContext(), null);
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
                    AppletUtils.moveCurrentAppletToFront(getContext(), null);
                    callback.onFailure();
                }

                @Override
                public void notImplemented() {

                }
            });
        });
    }
}
