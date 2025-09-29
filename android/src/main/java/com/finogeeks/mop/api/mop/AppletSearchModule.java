package com.finogeeks.mop.api.mop;

import android.content.Context;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.model.SearchAppletRequest;
import com.finogeeks.lib.applet.sdk.model.SearchAppletResponse;
import com.finogeeks.lib.applet.sdk.model.AppletInfo;
import com.finogeeks.lib.applet.sdk.model.HighLight;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.utils.GsonUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppletSearchModule extends BaseApi {
    private final static String TAG = AppletSearchModule.class.getSimpleName();

    public AppletSearchModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"searchApplets"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("searchApplets".equals(event)) {
            searchApplets(param, callback);
        }
    }

    private void searchApplets(Map param, ICallback callback) {
        String text = (String) param.get("text");
        String apiServer = (String) param.get("apiServer");

        if (text == null || apiServer == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing required parameters");
            }});
            return;
        }

        SearchAppletRequest request = new SearchAppletRequest(apiServer, text);

        FinAppClient.INSTANCE.getAppletApiManager().searchApplet(
            request,
            new FinCallback<SearchAppletResponse>() {
                @Override
                public void onSuccess(SearchAppletResponse result) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("total", result != null ? result.getTotal() : 0);
                    List<Map<String, Object>> list = new ArrayList<>();
                    if (result != null && result.getList() != null) {
                        for (AppletInfo info : result.getList()) {
                            Map<String, Object> appletMap = GsonUtil.toMap(info);
                            list.add(appletMap);
                        }
                    }
                    map.put("list", list);
                    callback.onSuccess(map);
                }
                @Override
                public void onError(int code, String error) {
                    callback.onFail(new HashMap<String, Object>() {{
                        put("error", error);
                        put("code", code);
                    }});
                }

                @Override
                public void onProgress(int status, String info) {
                    // 忽略进度回调
                }
            }
        );
    }
}