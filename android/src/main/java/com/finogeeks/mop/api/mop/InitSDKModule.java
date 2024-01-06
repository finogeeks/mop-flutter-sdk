package com.finogeeks.mop.api.mop;

import android.app.Application;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppConfig;
import com.finogeeks.lib.applet.client.FinAppConfigPriority;
import com.finogeeks.lib.applet.client.FinStoreConfig;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.api.mop.util.InitUtils;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;
import com.finogeeks.mop.impls.MyUserProfileHandler;
import com.finogeeks.xlog.XLogLevel;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Locale;

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
            Boolean enablePreloadFramework = (Boolean) store.get("enablePreloadFramework");
            //凡泰助手里，服务器是https://api.finclip.com，默认开启预加载基础库
            if (!TextUtils.isEmpty(apiServer) && apiServer.equals("https://api.finclip.com")) {
                enablePreloadFramework = true;
            }


            storeConfigs.add(new FinStoreConfig(sdkKey, sdkSecret, apiServer, apmServer, "",
                    fingerprint, cryptType, encryptServerData, enablePreloadFramework));
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
        configBuilder.setDebugMode((Boolean) configMap.get("debug"));
        configBuilder.setEnableLog((Boolean) configMap.get("debug"));
        Integer maxRunningApplet = (Integer) configMap.get("maxRunningApplet");
        if (maxRunningApplet != null) {
            configBuilder.setMaxRunningApplet(maxRunningApplet);
        }

        Integer backgroundFetchPeriod = (Integer) configMap.get("backgroundFetchPeriod");
        if (backgroundFetchPeriod != null) {
            configBuilder.setBackgroundFetchPeriod(backgroundFetchPeriod);
        }

        Integer webViewMixedContentMode = (Integer) configMap.get("webViewMixedContentMode");
        if (webViewMixedContentMode != null) {
            configBuilder.setWebViewMixedContentMode(webViewMixedContentMode);
        }
        configBuilder.setBindAppletWithMainProcess((Boolean) configMap.get("bindAppletWithMainProcess"));
        String killAppletProcessNotice = (String) configMap.get("killAppletProcessNotice");
        if (killAppletProcessNotice != null) {
            configBuilder.setKillAppletProcessNotice(killAppletProcessNotice);
        }
        configBuilder.setMinAndroidSdkVersion((Integer) configMap.get("minAndroidSdkVersion"));
        configBuilder.setEnableScreenShot((Boolean) configMap.get("enableScreenShot"));
        int screenShotPriorityIndex = (Integer) configMap.get("screenShotPriority");
        if (screenShotPriorityIndex == 0) {
            configBuilder.setScreenShotPriority(FinAppConfigPriority.GLOBAL);
        } else if (screenShotPriorityIndex == 1) {
            configBuilder.setScreenShotPriority(FinAppConfigPriority.SPECIFIED);
        } else if (screenShotPriorityIndex == 2) {
            configBuilder.setScreenShotPriority(FinAppConfigPriority.APPLET_FILE);
        }
        int logLevelIndex = (Integer) configMap.get("logLevel");
        if (logLevelIndex == 0) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_ERROR);
        } else if (logLevelIndex == 1) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_WARNING);
        } else if (logLevelIndex == 2) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_INFO);
        } else if (logLevelIndex == 3) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_DEBUG);
        } else if (logLevelIndex == 4) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_VERBOSE);
        } else if (logLevelIndex == 5) {
            configBuilder.setLogLevel(XLogLevel.LEVEL_NONE);
        }
        Integer logMaxAliveSec = (Integer) configMap.get("logMaxAliveSec");
        if (logMaxAliveSec != null) {
            configBuilder.setLogMaxAliveSec(logMaxAliveSec);
        }
        String logDir = (String) configMap.get("logDir");
        if (logDir != null) {
            configBuilder.setXLogDir(logDir);
        }
        configBuilder.setEnablePreNewProcess((Boolean) configMap.get("enablePreNewProcess"));
        configBuilder.setUseLocalTbsCore((Boolean) configMap.get("useLocalTbsCore"));
        String tbsCoreUrl = (String) configMap.get("tbsCoreUrl");
        if (tbsCoreUrl != null) {
            configBuilder.setTbsCoreUrl(tbsCoreUrl);
        }
        configBuilder.setEnableJ2V8((Boolean) configMap.get("enableJ2V8"));
        Map<Object, Object> uiConfigMap = (Map<Object, Object>) param.get("uiConfig");
        String appendingCustomUserAgent = (String) uiConfigMap.get("appendingCustomUserAgent");
        if (appendingCustomUserAgent != null) {
            configBuilder.setCustomWebViewUserAgent(appendingCustomUserAgent);
        }
        String appletText = (String) uiConfigMap.get("appletText");
        if (appletText != null) {
            configBuilder.setAppletText(appletText);
        }

        Object localeLanguage = configMap.get("localeLanguage");
        if (localeLanguage != null) {
            String language = (String) localeLanguage;
            if (language.contains("_")) {
                String[] locales = language.split("_");
                configBuilder.setLocale(new Locale(locales[0], locales[1]));
            } else {
                configBuilder.setLocale(new Locale(language));
            }
        } else {
            Integer languageInteger = (Integer) configMap.get("language");
            if (languageInteger == 1) {
                configBuilder.setLocale(Locale.ENGLISH);
            } else {
                configBuilder.setLocale(Locale.SIMPLIFIED_CHINESE);
            }
        }

        // uiConfig
        FinAppConfig.UIConfig uiConfig = InitUtils.createUIConfigFromMap(uiConfigMap);
        if (uiConfig != null) {
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

}
