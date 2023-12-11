package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.client.FinAppInfo;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.lib.applet.sdk.api.request.IFinAppletRequest;
import com.finogeeks.lib.applet.sdk.model.StartAppletDecryptRequest;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.HashMap;
import java.util.Map;

public class AppletModule extends BaseApi {
    private final static String TAG = AppletModule.class.getSimpleName();
    private Context mContext;

    public AppletModule(Context context) {
        super(context);
        mContext = context;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public String[] apis() {
        return new String[]{"openApplet", "scanOpenApplet","qrcodeOpenApplet", "changeUserId", "startApplet"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("openApplet".equals(event)) {
            openApplet(param, callback);
        } else if ("scanOpenApplet".equals(event)) {
            scanOpenApplet(param, callback);
        } else if ("qrcodeOpenApplet".equals(event)){
            qrcodeOpenApplet(param,callback);
        } else if ("changeUserId".equals(event)) {
            changeUserId(param, callback);
        } else if ("startApplet".equals(event)) {
            startApplet(param, callback);
        }
    }

    private void openApplet(Map param, ICallback callback) {
        if (param.get("appId") == null) {
            callback.onFail(new HashMap() {
                {
                    put("info", "appId不能为空");
                }
            });
            return;
        }
        Log.d("MopPlugin", "openApplet:params:" + param);
        String appId = String.valueOf(param.get("appId"));
        Integer sequence = (Integer) param.get("sequence");
        Map<String, String> params = (Map) param.get("params");
        String apiServer = (String) param.get("apiServer");
        Boolean isSingleProcess = (Boolean) param.get("isSingleProcess");
        IFinAppletRequest.ProcessMode processMode;
        if (Boolean.TRUE.equals(isSingleProcess)) {
            processMode = IFinAppletRequest.ProcessMode.SINGLE;
        } else {
            processMode = IFinAppletRequest.ProcessMode.MULTI;
        }
        // mContext是FlutterActivity，
        // 在Android 6.0、7.0系统的部分设备中热启动小程序时，如果context参数用mContext，会出现无法启动小程序的问题
        // 所以这里使用Application Context
        Context context = mContext.getApplicationContext();
        FinAppInfo.StartParams startParams = params == null ? null : new FinAppInfo.StartParams(params);
        Log.d(TAG, "openApplet:" + appId + "," + param + "," + sequence + "," + apiServer + ", isSingleProcess:" + isSingleProcess);

        if (apiServer != null) {
            FinAppClient.INSTANCE.getAppletApiManager().startApplet(context,
                    IFinAppletRequest.Companion.fromAppId(apiServer, appId)
                            .setStartParams(startParams)
                            .setSequence(sequence)
                            .setProcessMode(processMode),
                    null
            );
//            FinAppClient.INSTANCE.getAppletApiManager().startApplet(context, apiServer, appId, sequence, startParams,null);
        } else {
            FinAppClient.INSTANCE.getAppletApiManager().startApplet(context,
                    IFinAppletRequest.Companion.fromAppId(appId)
                            .setStartParams(startParams)
                            .setSequence(sequence)
                            .setProcessMode(processMode),
                    null
            );
        }

//        String apiServer = (String) param.get("apiServer");
//        String apiPrefix = (String) param.get("apiPrefix");
//        if (apiServer == null || apiServer.isEmpty() || apiPrefix == null || apiPrefix.isEmpty()) {
//            if (params == null) {
//                if (sequence == null) {
//                    FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId);
//                } else {
//                    FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, sequence, null);
//                }
//            } else {
//                FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, appId, params);
//            }
//        } else {
//            String fingerprint = (String) param.get("fingerprint");
//            if (fingerprint == null) {
//                fingerprint = "";
//            }
//            String cryptType = (String) param.get("cryptType");
//            if (cryptType == null || cryptType.isEmpty()) {
//                cryptType = FinAppConfig.ENCRYPTION_TYPE_MD5;
//            }
//            FinAppletStoreConfig finAppletStoreConfig = new FinAppletStoreConfig(apiServer, apiPrefix, fingerprint, cryptType);
//            FinAppInfo.StartParams startParams = null;
//            if (params != null) {
//                String pageURL = params.get("path");
//                String launchParams = params.get("query");
//                String scene = params.get("scene");
//                startParams = new FinAppInfo.StartParams(pageURL, launchParams, scene);
//            }
//            Log.d("MopPlugin", "openApplet:finAppletStoreConfig:" + finAppletStoreConfig.toString());
//            Log.d("MopPlugin", "openApplet:appId:" + appId);
//            Log.d("MopPlugin", "openApplet:sequence:" + sequence);
//            Log.d("MopPlugin", "openApplet:startParams:" + startParams);
//            FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, finAppletStoreConfig, appId, sequence, startParams);
//        }
        callback.onSuccess(new HashMap());
    }

    private void startApplet(Map param, ICallback callback) {
        if (param.get("appletId") == null) {
            callback.onFail(new HashMap() {
                {
                    put("info", "appId不能为空");
                }
            });
            return;
        }
        Log.d("MopPlugin", "startApplet:params:" + param);
        String appId = String.valueOf(param.get("appletId"));
        Integer sequence = (Integer) param.get("sequence");
        Map<String, String> params = (Map) param.get("startParams");
        if (params == null) {
            params = new HashMap<>();
        }
        String apiServer = (String) param.get("apiServer");
        String offlineMiniprogramZipPath = (String) param.get("offlineMiniprogramZipPath");
        String offlineFrameworkZipPath = (String) param.get("offlineFrameworkZipPath");
        Boolean isSingleProcess = (Boolean) param.get("isSingleProcess");
        IFinAppletRequest.ProcessMode processMode;
        if (Boolean.TRUE.equals(isSingleProcess)) {
            processMode = IFinAppletRequest.ProcessMode.SINGLE;
        } else {
            processMode = IFinAppletRequest.ProcessMode.MULTI;
        }

        Log.d("MopPlugin", "startApplet (appId=" + appId + ", sequence=" + sequence + ", apiServer=" + apiServer + ", isSingleProcess:" + isSingleProcess);
        // mContext是FlutterActivity，
        // 在Android 6.0、7.0系统的部分设备中热启动小程序时，如果context参数用mContext，会出现无法启动小程序的问题
        // 所以这里使用Application Context
        Context context = mContext.getApplicationContext();
//        String dir = context.getFilesDir();
        // FinAppInfo.StartParams startParams = params == null ? null : new FinAppInfo.StartParams(params.get("path"), params.get("query"), params.get("scene"));
        // Log.d(TAG, "openApplet:" + appId + "," + param + "," + apiServer);

        FinAppClient.INSTANCE.getAppletApiManager().startApplet(context,
                IFinAppletRequest.Companion.fromAppId(apiServer, appId)
                        .setSequence(sequence)
                        .setStartParams(params)
                        .setOfflineParams(offlineFrameworkZipPath, offlineMiniprogramZipPath)
                        .setProcessMode(processMode),
                null);
        // 改成通过request来启动小程序
        // FinAppClient.INSTANCE.getAppletApiManager().startApplet(context, IFinAppletRequest.Companion.fromAppId("apiServer", "appId")
        // .setStartParams(params).setOfflinexxxx);
        callback.onSuccess(new HashMap());
    }

    private void scanOpenApplet(Map param, ICallback callback) {
        String info = String.valueOf(param.get("info"));
        Boolean isSingleProcess = (Boolean) param.get("isSingleProcess");
        IFinAppletRequest.ProcessMode processMode;
        if (Boolean.TRUE.equals(isSingleProcess)) {
            processMode = IFinAppletRequest.ProcessMode.SINGLE;
        } else {
            processMode = IFinAppletRequest.ProcessMode.MULTI;
        }
        FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, IFinAppletRequest.Companion.fromDecrypt(info)
                .setProcessMode(processMode), null);
//        FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, new StartAppletDecryptRequest(info),null);
        callback.onSuccess(new HashMap());
    }

    private void qrcodeOpenApplet(Map param, ICallback callback) {
        String qrcode = String.valueOf(param.get("qrcode"));
        Boolean isSingleProcess = (Boolean) param.get("isSingleProcess");
        IFinAppletRequest.ProcessMode processMode;
        if (Boolean.TRUE.equals(isSingleProcess)) {
            processMode = IFinAppletRequest.ProcessMode.SINGLE;
        } else {
            processMode = IFinAppletRequest.ProcessMode.MULTI;
        }
        FinAppClient.INSTANCE.getAppletApiManager().startApplet(mContext, IFinAppletRequest.Companion.fromQrCode(qrcode)
                .setProcessMode(processMode), new FinCallback<String>() {
            @Override
            public void onSuccess(String s) {
                callback.onSuccess(new HashMap());
            }

            @Override
            public void onError(int i, String s) {
                callback.onFail(s);
            }

            @Override
            public void onProgress(int i, String s) {

            }
        });
        /*FinAppClient.INSTANCE.getAppletApiManager().startAppletByQrcode(mContext, qrcode, new FinCallback<String>() {
            @Override
            public void onSuccess(String s) {
                callback.onSuccess(new HashMap());
            }

            @Override
            public void onError(int i, String s) {
                callback.onFail(new HashMap(){
                    {
                        put("info",s);
                    }
                });
            }

            @Override
            public void onProgress(int i, String s) {

            }
        });*/
    }

    private void changeUserId(Map param, ICallback callback) {
        String userId = String.valueOf(param.get("userId"));
        if (FinAppClient.INSTANCE.getFinAppConfig() != null) {
            FinAppClient.INSTANCE.getFinAppConfig().setUserId(userId);
            callback.onSuccess(new HashMap());
        } else {
            callback.onFail(new HashMap(){
                {
                    put("info", "sdk not initilized");
                }
            });
        }
    }
}