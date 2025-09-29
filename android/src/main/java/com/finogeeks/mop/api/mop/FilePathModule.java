package com.finogeeks.mop.api.mop;

import android.content.Context;
import android.text.TextUtils;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.api.FinFilePathType;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.HashMap;
import java.util.Map;

public class FilePathModule extends BaseApi {
    private final static String TAG = FilePathModule.class.getSimpleName();

    public FilePathModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"getFinFileAbsolutePath", "generateFinFilePath"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("getFinFileAbsolutePath".equals(event)) {
            getFinFileAbsolutePath(param, callback);
        } else if ("generateFinFilePath".equals(event)) {
            generateFinFilePath(param, callback);
        }
    }

    private void getFinFileAbsolutePath(Map param, ICallback callback) {
        String appId = (String) param.get("appId");
        String finFilePath = (String) param.get("finFilePath");
        Boolean needFileExist = (Boolean) param.get("needFileExist");

        if (finFilePath == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing finFilePath parameter");
            }});
            return;
        }

        if (TextUtils.isEmpty(appId)) {
            // 如果没有传入appId，则使用当前小程序的ID（如果有的话）
            appId = FinAppClient.INSTANCE.getAppletApiManager().getCurrentAppletId();
            if(TextUtils.isEmpty(appId)){
                callback.onFail(new HashMap<String, Object>() {{
                    put("error", "Missing appId parameter");
                }});
                return;
            }
        }

        try {
            String absolutePath;

            if (needFileExist == null || needFileExist) {
                // 需要文件存在
                absolutePath = FinAppClient.INSTANCE.getAppletApiManager().getFinFileAbsolutePath(
                        getContext(), appId, finFilePath
                );
            } else {
                // 不需要文件存在
                absolutePath = FinAppClient.INSTANCE.getAppletApiManager().getFinFileAbsolutePathCanNoExist(
                        getContext(), appId, finFilePath
                );
            }

            Map<String, Object> result = new HashMap<>();
            result.put("path", absolutePath);
            callback.onSuccess(result);
        } catch (Exception e) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", e.getMessage());
            }});
        }
    }

    private void generateFinFilePath(Map param, ICallback callback) {
        String fileName = (String) param.get("fileName");
        Integer pathTypeIndex = (Integer) param.get("pathType");

        if (fileName == null || pathTypeIndex == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing required parameters");
            }});
            return;
        }

        try {
            FinFilePathType pathType;
            // 根据Flutter枚举顺序匹配：TMP=0, STORE=1, USR=2
            switch (pathTypeIndex) {
                case 0:  // TMP
                    pathType = FinFilePathType.TMP;
                    break;
                case 1:  // STORE
                    pathType = FinFilePathType.STORE;
                    break;
                case 2:  // USR
                    pathType = FinFilePathType.USR;
                    break;
                default:
                    throw new IllegalArgumentException("Invalid pathType: " + pathTypeIndex);
            }

            String finFilePath = FinAppClient.INSTANCE.getAppletApiManager().generateFinFilePath(
                    fileName, pathType
            );

            Map<String, Object> result = new HashMap<>();
            result.put("path", finFilePath);
            callback.onSuccess(result);
        } catch (Exception e) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", e.getMessage());
            }});
        }
    }
}