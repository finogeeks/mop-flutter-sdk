package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.anim.FadeInAnim;
import com.finogeeks.lib.applet.anim.NoneAnim;
import com.finogeeks.lib.applet.anim.SlideFromBottomToTopAnim;
import com.finogeeks.lib.applet.anim.SlideFromLeftToRightAnim;
import com.finogeeks.lib.applet.anim.SlideFromRightToLeftAnim;
import com.finogeeks.lib.applet.anim.SlideFromTopToBottomAnim;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppInfo;
import com.finogeeks.lib.applet.client.FinAppProcessClient;
import com.finogeeks.lib.applet.db.entity.FinApplet;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.lib.applet.rest.model.WechatLoginInfo;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.utils.AppletUtils;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;


public class AppletManageModule extends BaseApi {

    private static final String TAG = "AppletManageModule";

    public AppletManageModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"currentApplet", "closeAllApplets", "clearApplets",
                "removeUsedApplet", "removeAllUsedApplets", "closeApplet",
                "setActivityTransitionAnim", "sendCustomEvent", "callJS", "finishRunningApplet",
                "moveCurrentAppletToFront"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if (event.equals("currentApplet")) {
            String appId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
            if (appId != null) {
                FinAppInfo appletInfo = FinAppClient.INSTANCE.getAppletApiManager().getAppletInfoFromRunning(appId);
                if (appletInfo != null) {
                    //Log.e(TAG, "applet:" + new Gson().toJson(applet));
                    Map<String, Object> res = new HashMap<>();
                    res.put("appId", appletInfo.getAppId());
                    res.put("name", appletInfo.getAppTitle());
                    res.put("icon", appletInfo.getAppAvatar());
                    res.put("description", appletInfo.getAppDescription());
                    res.put("version", appletInfo.getAppVersion());
                    res.put("thumbnail", appletInfo.getAppThumbnail());
                    res.put("appletType", appletInfo.getAppType());
                    res.put("isSingleProcess", FinAppProcessClient.INSTANCE.getAppletProcessActivity(appletInfo.getAppId()) != null);
                    Map<String, String> wechatLoginInfo = new HashMap<>(4);
                    WechatLoginInfo wechatLogin = appletInfo.getWechatLoginInfo();
                    if (wechatLogin != null) {
                        wechatLoginInfo.put("wechatOriginId", wechatLogin.getWechatOriginId());
                        wechatLoginInfo.put("profileUrl", wechatLogin.getProfileUrl());
                        wechatLoginInfo.put("phoneUrl", wechatLogin.getPhoneUrl());
                        wechatLoginInfo.put("paymentUrl", wechatLogin.getPaymentUrl());
                        res.put("wechatLoginInfo",wechatLoginInfo);
                    }else{
                        res.put("wechatLoginInfo", null);
                    }
                    callback.onSuccess(res);
                } else {
                    callback.onSuccess(null);
                }
            } else {
                callback.onSuccess(null);
            }
        } else if (event.equals("closeAllApplets")) {
            FinAppClient.INSTANCE.getAppletApiManager().closeApplets();
            callback.onSuccess(null);
        } else if (event.equals("finishRunningApplet")) {
            if (param.containsKey("appletId") && param.get("appletId") instanceof String) {
                String appId = (String) param.get("appletId");
                FinAppClient.INSTANCE.getAppletApiManager().finishRunningApplet(appId);
                callback.onSuccess(null);
            } else {
                callback.onFail(null);
            }
        } else if (event.equals("closeApplet")) {
            if (param.containsKey("appletId") && param.get("appletId") instanceof String) {
                String appId = (String) param.get("appletId");
                FinAppClient.INSTANCE.getAppletApiManager().closeApplet(appId);
                callback.onSuccess(null);
            } else {
                callback.onFail(null);
            }
        } else if (event.equals("clearApplets")) {
            FinAppClient.INSTANCE.getAppletApiManager().finishAllRunningApplets();
            callback.onSuccess(null);
        } else if (event.equals("removeUsedApplet")) {
            Log.d("MopPlugin", "removeUsedApplet:params:" + param);
            if (param.containsKey("appId") && param.get("appId") instanceof String) {
                String appId = (String) param.get("appId");
                FinAppClient.INSTANCE.getAppletApiManager().removeUsedApplet(appId);
                callback.onSuccess(null);
            } else {
                callback.onFail(null);
            }
        } else if(event.equals("removeAllUsedApplets")){
            Log.e(TAG,"removeAllUsedApplets");
            FinAppClient.INSTANCE.getAppletApiManager().removeAllUsedApplets();
        }else if (event.equals("setActivityTransitionAnim")) {
            String anim = (String) param.get("anim");
            Log.d(TAG, "setActivityTransitionAnim:" + anim);
            if ("SlideFromLeftToRightAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(SlideFromLeftToRightAnim.INSTANCE);
            } else if ("SlideFromRightToLeftAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(SlideFromRightToLeftAnim.INSTANCE);
            } else if ("SlideFromTopToBottomAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(SlideFromTopToBottomAnim.INSTANCE);
            } else if ("SlideFromBottomToTopAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(SlideFromBottomToTopAnim.INSTANCE);
            } else if ("FadeInAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(FadeInAnim.INSTANCE);
            } else if ("NoneAnim".equals(anim)) {
                FinAppClient.INSTANCE.getAppletApiManager().setActivityTransitionAnim(NoneAnim.INSTANCE);
            }
            callback.onSuccess(null);
        } else if (event.equals("sendCustomEvent")) {
            String appId = (String) param.get("appId");
            Map eventData = (Map) param.get("eventData");
            Log.d(TAG, "sendCustomEvent:" + appId);
            if (appId != null) {
                FinAppClient.INSTANCE.getAppletApiManager().sendCustomEvent(appId, eventData == null ? "" : new Gson().toJson(eventData));
                callback.onSuccess(null);
            } else {
                callback.onFail(null);
            }
        } else if (event.equals("callJS")) {
            String appId = (String) param.get("appId");
            String eventName = (String) param.get("eventName");
            String nativeViewId = (String) param.get("nativeViewId");
            int viewId = 0;
            if (nativeViewId != null && !nativeViewId.equals("")) {
                try {
                    viewId = Integer.parseInt(nativeViewId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            Map eventData = (Map) param.get("eventData");
            Log.d(TAG, "callJS:" + appId);
            if (appId != null && eventName != null) {
                FinAppClient.INSTANCE.getAppletApiManager().callJS(appId, eventName, eventData == null ? "" : new Gson().toJson(eventData),
                        viewId, new FinCallback<String>() {
                            @Override
                            public void onSuccess(String s) {
                                Map<String, Object> res = new HashMap<>();
                                res.put("data", s);
                                callback.onSuccess(res);
                            }

                            @Override
                            public void onError(int i, String s) {
                                callback.onFail(null);
                            }

                            @Override
                            public void onProgress(int i, String s) {

                            }
                        });
            } else {
                callback.onFail(null);
            }
        } else if (event.equals("moveCurrentAppletToFront")) {
            AppletUtils.moveCurrentAppletToFront(getContext(), callback);
        }
    }
}
