package com.finogeeks.mop.api.mop;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.client.FinAppConfigPriority;
import com.finogeeks.lib.applet.client.FinStoreConfig;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class InitSDKModule extends BaseApi {

    private final static String TAG = "InitSDKModule";

    public InitSDKModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"initSDK"};
    }

    @Override
    @SuppressWarnings("unchecked")
    public void invoke(String event, Map param, ICallback callback) {
        if (FinAppClient.INSTANCE.isFinAppProcess(super.getContext())) {
            // 小程序进程不执行任何初始化操作
            return;
        }

        Log.d(TAG, "param:" + param);
        FinAppConfig.Builder configBuilder = new FinAppConfig.Builder();

        // config
        Map<Object, Object> configMap = (Map<Object, Object>) param.get("config");
        List<Map<Object, Object>> finStoreConfigs = (List<Map<Object, Object>>) configMap.get("finStoreConfigs");
        List<FinStoreConfig> storeConfigs = new ArrayList<>();
        for (Map<Object, Object> store : finStoreConfigs) {
            String sdkKey = (String) store.get("sdkKey");
            String sdkSecret = (String) store.get("sdkSecret");
            String apiServer = (String) store.get("apiServer");
            String apmServer = (String) store.get("apmServer");
            if (apmServer == null) {
                apmServer = "";
            }
            String fingerprint = (String) store.get("fingerprint");
            if (fingerprint == null) {
                fingerprint = "";
            }
            String cryptType = (String) store.get("cryptType");
            Boolean encryptServerData = (Boolean) store.get("encryptServerData");
            storeConfigs.add(new FinStoreConfig(sdkKey, sdkSecret, apiServer, apmServer, "",
                    fingerprint, cryptType, encryptServerData));
        }
        configBuilder.setFinStoreConfigs(storeConfigs);
        String userId = (String) configMap.get("userId");
        if (userId != null) {
            configBuilder.setUserId(userId);
        }
        String productIdentification = (String) configMap.get("productIdentification");
        if (productIdentification != null) {
            configBuilder.setProductIdentification(productIdentification);
        }
        configBuilder.setDisableRequestPermissions((Boolean) configMap.get("disableRequestPermissions"));
        configBuilder.setAppletAutoAuthorize((Boolean) configMap.get("appletAutoAuthorize"));
        configBuilder.setDisableGetSuperviseInfo((Boolean) configMap.get("disableGetSuperviseInfo"));
        configBuilder.setIgnoreWebviewCertAuth((Boolean) configMap.get("ignoreWebviewCertAuth"));
        configBuilder.setAppletIntervalUpdateLimit((Integer) configMap.get("appletIntervalUpdateLimit"));
        Map<String, Object> apmExtendInfo = (Map<String, Object>) configMap.get("apmExtendInfo");
        if (apmExtendInfo != null) {
            configBuilder.setApmExtendInfo(apmExtendInfo);
        }
        configBuilder.setEnableApmDataCompression((Boolean) configMap.get("enableApmDataCompression"));
        configBuilder.setEncryptServerData((Boolean) configMap.get("encryptServerData"));
        configBuilder.setEncryptServerData((Boolean) configMap.get("encryptServerData"));
        int appletDebugModeIndex = (Integer) configMap.get("appletDebugMode");
        if (appletDebugModeIndex == 0) {
            configBuilder.setAppletDebugMode(FinAppConfig.AppletDebugMode.appletDebugModeUndefined);
        } else if (appletDebugModeIndex == 1) {
            configBuilder.setAppletDebugMode(FinAppConfig.AppletDebugMode.appletDebugModeEnable);
        } else if (appletDebugModeIndex == 2) {
            configBuilder.setAppletDebugMode(FinAppConfig.AppletDebugMode.appletDebugModeDisable);
        } else if (appletDebugModeIndex == 3) {
            configBuilder.setAppletDebugMode(FinAppConfig.AppletDebugMode.appletDebugModeForbidden);
        }
        configBuilder.setEnableWatermark((Boolean) configMap.get("enableWatermark"));
        int watermarkPriorityIndex = (Integer) configMap.get("watermarkPriority");
        if (watermarkPriorityIndex == 0) {
            configBuilder.setWatermarkPriority(FinAppConfigPriority.GLOBAL);
        } else if (watermarkPriorityIndex == 1) {
            configBuilder.setWatermarkPriority(FinAppConfigPriority.SPECIFIED);
        } else if (watermarkPriorityIndex == 2) {
            configBuilder.setWatermarkPriority(FinAppConfigPriority.APPLET_FILE);
        }
        Map<String, String> header = (Map<String, String>) configMap.get("header");
        if (header != null) {
            configBuilder.setHeader(header);
        }
        int headerPriorityIndex = (Integer) configMap.get("headerPriority");
        if (headerPriorityIndex == 0) {
            configBuilder.setHeaderPriority(FinAppConfigPriority.GLOBAL);
        } else if (headerPriorityIndex == 1) {
            configBuilder.setHeaderPriority(FinAppConfigPriority.SPECIFIED);
        } else if (headerPriorityIndex == 2) {
            configBuilder.setHeaderPriority(FinAppConfigPriority.APPLET_FILE);
        }
        configBuilder.setPageCountLimit((Integer) configMap.get("pageCountLimit"));
        String[] schemes = (String[]) configMap.get("schemes");
        if (schemes != null) {
            configBuilder.setSchemes(schemes);
        }

        // uiConfig
        Map<Object, Object> uiConfigMap = (Map<Object, Object>) param.get("uiConfig");
        if (uiConfigMap != null) {
            FinAppConfig.UIConfig uiConfig = new FinAppConfig.UIConfig();
            uiConfig.setNavigationBarTitleLightColor((Integer) uiConfigMap.get("navigationBarTitleLightColor"));
            uiConfig.setNavigationBarTitleDarkColor((Integer) uiConfigMap.get("navigationBarTitleDarkColor"));
            uiConfig.setNavigationBarBackBtnLightColor((Integer) uiConfigMap.get("navigationBarBackBtnLightColor"));
            uiConfig.setAlwaysShowBackInDefaultNavigationBar((Boolean) uiConfigMap.get("isAlwaysShowBackInDefaultNavigationBar"));
            uiConfig.setClearNavigationBarNavButtonBackground((Boolean) uiConfigMap.get("isClearNavigationBarNavButtonBackground"));
            uiConfig.setHideFeedbackAndComplaints((Boolean) uiConfigMap.get("isHideFeedbackAndComplaints"));
            uiConfig.setHideBackHome((Boolean) uiConfigMap.get("isHideBackHome"));
            uiConfig.setHideForwardMenu((Boolean) uiConfigMap.get("isHideForwardMenu"));
            uiConfig.setHideRefreshMenu((Boolean) uiConfigMap.get("isHideRefreshMenu"));
            uiConfig.setHideShareAppletMenu((Boolean) uiConfigMap.get("isHideShareAppletMenu"));
            uiConfig.setHideSettingMenu((Boolean) uiConfigMap.get("isHideSettingMenu"));
            uiConfig.setHideTransitionCloseButton((Boolean) uiConfigMap.get("hideTransitionCloseButton"));
            Map<Object, Object> capsuleConfigMap = (Map<Object, Object>) uiConfigMap.get("capsuleConfig");
            if (capsuleConfigMap != null) {
                FinAppConfig.UIConfig.CapsuleConfig capsuleConfig = new FinAppConfig.UIConfig.CapsuleConfig();
                capsuleConfig.capsuleWidth = (float) capsuleConfigMap.get("capsuleWidth");
                capsuleConfig.capsuleHeight = (float) capsuleConfigMap.get("capsuleHeight");
                capsuleConfig.capsuleRightMargin = (float) capsuleConfigMap.get("capsuleRightMargin");
                capsuleConfig.capsuleCornerRadius = (float) capsuleConfigMap.get("capsuleCornerRadius");
                capsuleConfig.capsuleBorderWidth = (float) capsuleConfigMap.get("capsuleBorderWidth");
                capsuleConfig.capsuleBgLightColor = (int) capsuleConfigMap.get("capsuleBgLightColor");
                capsuleConfig.capsuleBgDarkColor = (int) capsuleConfigMap.get("capsuleBgDarkColor");
                capsuleConfig.capsuleBorderLightColor = (int) capsuleConfigMap.get("capsuleBorderLightColor");
                capsuleConfig.capsuleBorderDarkColor = (int) capsuleConfigMap.get("capsuleBorderDarkColor");
                capsuleConfig.capsuleDividerLightColor = (int) capsuleConfigMap.get("capsuleDividerLightColor");
                capsuleConfig.capsuleDividerDarkColor = (int) capsuleConfigMap.get("capsuleDividerDarkColor");
                Integer moreLightImage = (Integer) capsuleConfigMap.get("moreLightImage");
                if (moreLightImage != null) {
                    capsuleConfig.moreLightImage = moreLightImage;
                }
                Integer moreDarkImage = (Integer) capsuleConfigMap.get("moreDarkImage");
                if (moreDarkImage != null) {
                    capsuleConfig.moreDarkImage = moreDarkImage;
                }
                capsuleConfig.moreBtnWidth = (float) capsuleConfigMap.get("moreBtnWidth");
                capsuleConfig.moreBtnLeftMargin = (float) capsuleConfigMap.get("moreBtnLeftMargin");
                Integer closeLightImage = (Integer) capsuleConfigMap.get("closeLightImage");
                if (closeLightImage != null) {
                    capsuleConfig.closeLightImage = closeLightImage;
                }
                Integer closeDarkImage = (Integer) capsuleConfigMap.get("closeDarkImage");
                if (closeDarkImage != null) {
                    capsuleConfig.closeDarkImage = closeDarkImage;
                }
                capsuleConfig.closeBtnWidth = (float) capsuleConfigMap.get("closeBtnWidth");
                capsuleConfig.closeBtnLeftMargin = (float) capsuleConfigMap.get("closeBtnLeftMargin");
                uiConfig.setCapsuleConfig(capsuleConfig);
            }
            Map<Object, Object> navHomeConfigMap = (Map<Object, Object>) uiConfigMap.get("navHomeConfig");
            if (navHomeConfigMap != null) {
                FinAppConfig.UIConfig.NavHomeConfig navHomeConfig = new FinAppConfig.UIConfig.NavHomeConfig();
                navHomeConfig.width = (float) navHomeConfigMap.get("width");
                navHomeConfig.height = (float) navHomeConfigMap.get("height");
                navHomeConfig.leftMargin = (float) navHomeConfigMap.get("leftMargin");
                navHomeConfig.cornerRadius = (float) navHomeConfigMap.get("cornerRadius");
                navHomeConfig.borderWidth = (float) navHomeConfigMap.get("borderWidth");
                navHomeConfig.borderLightColor = (int) navHomeConfigMap.get("borderLightColor");
                navHomeConfig.borderDarkColor = (int) navHomeConfigMap.get("borderDarkColor");
                navHomeConfig.bgLightColor = (int) navHomeConfigMap.get("bgLightColor");
                navHomeConfig.bgDarkColor = (int) navHomeConfigMap.get("bgDarkColor");
                uiConfig.setNavHomeConfig(navHomeConfig);
            }
            Map<Object, Object> authViewConfigMap = (Map<Object, Object>) uiConfigMap.get("authViewConfig");
            if (authViewConfigMap != null) {
                FinAppConfig.UIConfig.AuthViewConfig authViewConfig = new FinAppConfig.UIConfig.AuthViewConfig();
                authViewConfig.appletNameTextSize = (float) authViewConfigMap.get("appletNameTextSize");
                authViewConfig.appletNameLightColor = (int) authViewConfigMap.get("appletNameLightColor");
                authViewConfig.appletNameDarkColor = (int) authViewConfigMap.get("appletNameDarkColor");
                authViewConfig.authorizeTitleTextSize = (float) authViewConfigMap.get("authorizeTitleTextSize");
                authViewConfig.authorizeTitleLightColor = (int) authViewConfigMap.get("authorizeTitleLightColor");
                authViewConfig.authorizeTitleDarkColor = (int) authViewConfigMap.get("authorizeTitleDarkColor");
                authViewConfig.authorizeDescriptionTextSize = (float) authViewConfigMap.get("authorizeDescriptionTextSize");
                authViewConfig.authorizeDescriptionLightColor = (int) authViewConfigMap.get("authorizeDescriptionLightColor");
                authViewConfig.authorizeDescriptionDarkColor = (int) authViewConfigMap.get("authorizeDescriptionDarkColor");
                authViewConfig.agreementTitleTextSize = (float) authViewConfigMap.get("agreementTitleTextSize");
                authViewConfig.agreementTitleLightColor = (int) authViewConfigMap.get("agreementTitleLightColor");
                authViewConfig.agreementTitleDarkColor = (int) authViewConfigMap.get("agreementTitleDarkColor");
                authViewConfig.agreementDescriptionTextSize = (float) authViewConfigMap.get("agreementDescriptionTextSize");
                authViewConfig.agreementDescriptionLightColor = (int) authViewConfigMap.get("agreementDescriptionLightColor");
                authViewConfig.agreementDescriptionDarkColor = (int) authViewConfigMap.get("agreementDescriptionDarkColor");
                authViewConfig.linkLightColor = (int) authViewConfigMap.get("linkLightColor");
                authViewConfig.linkDarkColor = (int) authViewConfigMap.get("linkDarkColor");
                Map<Object, Object> allowButtonLightConfig = (Map<Object, Object>) authViewConfigMap.get("allowButtonLightConfig");
                if (allowButtonLightConfig != null) {
                    authViewConfig.allowButtonLightConfig = getAuthButtonConfig(allowButtonLightConfig);
                }
                Map<Object, Object> allowButtonDarkConfig = (Map<Object, Object>) authViewConfigMap.get("allowButtonDarkConfig");
                if (allowButtonDarkConfig != null) {
                    authViewConfig.allowButtonDarkConfig = getAuthButtonConfig(allowButtonDarkConfig);
                }
                Map<Object, Object> rejectButtonLightConfig = (Map<Object, Object>) authViewConfigMap.get("rejectButtonLightConfig");
                if (rejectButtonLightConfig != null) {
                    authViewConfig.rejectButtonLightConfig = getAuthButtonConfig(rejectButtonLightConfig);
                }
                Map<Object, Object> rejectButtonDarkConfig = (Map<Object, Object>) authViewConfigMap.get("rejectButtonDarkConfig");
                if (rejectButtonDarkConfig != null) {
                    authViewConfig.rejectButtonDarkConfig = getAuthButtonConfig(rejectButtonDarkConfig);
                }
                uiConfig.setAuthViewConfig(authViewConfig);
            }
            Map<Object, Object> floatWindowConfigMap = (Map<Object, Object>) uiConfigMap.get("floatWindowConfig");
            if (floatWindowConfigMap != null) {
                FinAppConfig.UIConfig.FloatWindowConfig floatWindowConfig = new FinAppConfig.UIConfig.FloatWindowConfig();
                floatWindowConfig.floatMode = (boolean) floatWindowConfigMap.get("floatMode");
                floatWindowConfig.x = (int) floatWindowConfigMap.get("x");
                floatWindowConfig.y = (int) floatWindowConfigMap.get("y");
                floatWindowConfig.width = (int) floatWindowConfigMap.get("width");
                floatWindowConfig.height = (int) floatWindowConfigMap.get("height");
                uiConfig.setFloatWindowConfig(floatWindowConfig);
            }
            Integer webViewProgressBarColor = (Integer) uiConfigMap.get("webViewProgressBarColor");
            if (webViewProgressBarColor != null) {
                uiConfig.setWebViewProgressBarColor(webViewProgressBarColor);
            }
            uiConfig.setHideWebViewProgressBar((Boolean) uiConfigMap.get("hideWebViewProgressBar"));
            uiConfig.setMoreMenuStyle((Integer) uiConfigMap.get("moreMenuStyle"));
            int isHideBackHomePriorityIndex = (Integer) uiConfigMap.get("isHideBackHomePriority");
            if (isHideBackHomePriorityIndex == 0) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.GLOBAL);
            } else if (isHideBackHomePriorityIndex == 1) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.SPECIFIED);
            } else if (isHideBackHomePriorityIndex == 2) {
                uiConfig.setIsHideBackHomePriority(FinAppConfigPriority.APPLET_FILE);
            }
            uiConfig.setAutoAdaptDarkMode((Boolean) uiConfigMap.get("autoAdaptDarkMode"));
            String appendingCustomUserAgent = (String) uiConfigMap.get("appendingCustomUserAgent");
            if (appendingCustomUserAgent != null) {
                configBuilder.setCustomWebViewUserAgent(appendingCustomUserAgent);
            }
            uiConfig.setDisableSlideCloseAppletGesture((Boolean) uiConfigMap.get("disableSlideCloseAppletGesture"));
            String appletText = (String) uiConfigMap.get("appletText");
            if (appletText != null) {
                configBuilder.setAppletText(appletText);
            }
            String loadingLayoutCls = (String) uiConfigMap.get("loadingLayoutCls");
            if (loadingLayoutCls != null) {
//                uiConfig.setLoadingLayoutCls(loadingLayoutCls);
            }

            configBuilder.setUiConfig(uiConfig);
        }

        FinAppConfig finAppConfig = configBuilder.build();
        Log.d(TAG, "finAppConfig:" + new Gson().toJson(finAppConfig));

        final Application application = MopPluginService.getInstance().getActivity().getApplication();
        // SDK初始化结果回调，用于接收SDK初始化状态
        FinCallback<Object> cb = new FinCallback<Object>() {
            @Override
            public void onSuccess(Object result) {
                // SDK初始化成功
                callback.onSuccess(null);
            }

            @Override
            public void onError(int code, String error) {
                // SDK初始化失败
                callback.onFail(null);
            }

            @Override
            public void onProgress(int status, String error) {

            }
        };
        FinAppClient.INSTANCE.init(application, finAppConfig, cb);
    }

    private FinAppConfig.UIConfig.AuthViewConfig.AuthButtonConfig getAuthButtonConfig(Map<Object, Object> map) {
        return new FinAppConfig.UIConfig.AuthViewConfig.AuthButtonConfig(
                (float) map.get("cornerRadius"),
                (int) map.get("normalBackgroundColor"),
                (int) map.get("pressedBackgroundColor"),
                (int) map.get("normalBorderColor"),
                (int) map.get("pressedBorderColor"),
                (int) map.get("normalTextColor"),
                (int) map.get("pressedTextColor")
        );
    }
}
