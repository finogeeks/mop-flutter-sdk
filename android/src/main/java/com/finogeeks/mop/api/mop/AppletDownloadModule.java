package com.finogeeks.mop.api.mop;

import android.content.Context;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.model.AppletDownLoadInfo;
import com.finogeeks.lib.applet.interfaces.FinSimpleCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppletDownloadModule extends BaseApi {
    private final static String TAG = AppletDownloadModule.class.getSimpleName();

    public AppletDownloadModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"downloadApplets"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("downloadApplets".equals(event)) {
            downloadApplets(param, callback);
        }
    }

    private void downloadApplets(Map param, ICallback callback) {
        List<String> appIds = (List<String>) param.get("appIds");
        String apiServer = (String) param.get("apiServer");
        Boolean isBatchDownload = (Boolean) param.get("isBatchDownload");

        if (appIds == null || apiServer == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing required parameters");
            }});
            return;
        }

        boolean batchDownload = isBatchDownload != null ? isBatchDownload : true;

        FinAppClient.getAppletApiManager().downloadApplets(
            getContext(),
            apiServer,
            appIds,
            batchDownload,
            new FinSimpleCallback<List<AppletDownLoadInfo>>() {
                @Override
                public void onSuccess(List<AppletDownLoadInfo> results) {
                    List<Map<String, Object>> list = new ArrayList<>();
                    if (results != null) {
                        for (AppletDownLoadInfo info : results) {
                            Map<String, Object> map = new HashMap<>();
                            map.put("appId", info.getAppId());
                            map.put("success", info.isSuccess());
                            map.put("needUpdate", info.isNeedUpdate());
                            list.add(map);
                        }
                    }

                    Map<String, Object> result = new HashMap<>();
                    result.put("data", list);
                    callback.onSuccess(result);
                }

                @Override
                public void onError(int code, String error) {
                    callback.onFail(new HashMap<String, Object>() {{
                        put("error", error);
                        put("code", code);
                    }});
                }
            }
        );
    }
}