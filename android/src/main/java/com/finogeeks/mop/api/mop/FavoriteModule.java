package com.finogeeks.mop.api.mop;

import android.content.Context;
import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.api.IAppletApiManager;
import com.finogeeks.lib.applet.sdk.model.FavoriteAppletListRequest;
import com.finogeeks.lib.applet.sdk.model.FavoriteAppletListResp;
import com.finogeeks.lib.applet.sdk.model.AppletInfo;
import com.finogeeks.lib.applet.sdk.model.HighLight;
import com.finogeeks.lib.applet.helper.MoreMenuHelper;
import com.finogeeks.lib.applet.interfaces.FinCallback;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FavoriteModule extends BaseApi {
    private final static String TAG = FavoriteModule.class.getSimpleName();

    public FavoriteModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"updateAppletFavorite", "isAppletFavorite", "getFavoriteApplets"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        if ("updateAppletFavorite".equals(event)) {
            updateAppletFavorite(param, callback);
        } else if ("isAppletFavorite".equals(event)) {
            isAppletFavorite(param, callback);
        } else if ("getFavoriteApplets".equals(event)) {
            getFavoriteApplets(param, callback);
        }
    }

    private void updateAppletFavorite(Map param, ICallback callback) {
        // Android SDK只能操作当前小程序的收藏状态，不需要appletId
        Boolean favorite = (Boolean) param.get("favorite");

        if (favorite == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing favorite parameter");
            }});
            return;
        }

        MoreMenuHelper.updateAppletFavoriteState(
            getContext(),
            favorite,
            new FinCallback<Object>() {
                @Override
                public void onSuccess(Object result) {
                    callback.onSuccess(new HashMap<>());
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

    private void isAppletFavorite(Map param, ICallback callback) {
        // Android SDK只能查询当前小程序的收藏状态，appletId参数仅用于保持接口一致性
        try {
            Boolean isFavorite = MoreMenuHelper.isAppletFavorite(getContext());

            Map<String, Object> result = new HashMap<>();
            result.put("favorite", isFavorite != null ? isFavorite : false);
            callback.onSuccess(result);
        } catch (Exception e) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", e.getMessage());
            }});
        }
    }

    private void getFavoriteApplets(Map param, ICallback callback) {
        String apiServer = (String) param.get("apiServer");
        Integer pageNo = (Integer) param.get("pageNo");
        Integer pageSize = (Integer) param.get("pageSize");

        if (apiServer == null) {
            callback.onFail(new HashMap<String, Object>() {{
                put("error", "Missing apiServer parameter");
            }});
            return;
        }

        int page = pageNo != null ? pageNo : 0;
        int size = pageSize != null ? pageSize : 0;

        FavoriteAppletListRequest request = new FavoriteAppletListRequest(apiServer, page, size);

        FinAppClient.getAppletApiManager().getFavoriteApplets(
            request,
            new FinCallback<FavoriteAppletListResp>() {
                @Override
                public void onSuccess(FavoriteAppletListResp result) {
                    Map<String, Object> map = new HashMap<>();

                    if (result != null) {
                        map.put("total", result.getTotal());
                        map.put("pageNo", result.getPageNo());
                        map.put("pageSize", result.getPageSize());

                        List<Map<String, Object>> list = new ArrayList<>();
                        if (result.getList() != null) {
                            for (AppletInfo info : result.getList()) {
                                Map<String, Object> appletMap = new HashMap<>();
                                appletMap.put("appId", info.getAppId());
                                appletMap.put("appName", info.getAppName());
                                appletMap.put("desc", info.getDesc());
                                appletMap.put("logo", info.getLogo());
                                appletMap.put("organName", info.getOrganName());
                                appletMap.put("pageUrl", info.getPageUrl());
                                appletMap.put("showText", info.getShowText());

                                // 处理高亮信息
                                List<Map<String, String>> highLights = new ArrayList<>();
                                if (info.getHighLights() != null) {
                                    for (HighLight hl : info.getHighLights()) {
                                        Map<String, String> hlMap = new HashMap<>();
                                        hlMap.put("key", hl.getKey());
                                        hlMap.put("value", hl.getValue());
                                        highLights.add(hlMap);
                                    }
                                }
                                appletMap.put("highLights", highLights);

                                list.add(appletMap);
                            }
                        }
                        map.put("list", list);
                    } else {
                        map.put("total", 0);
                        map.put("list", new ArrayList<>());
                    }

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