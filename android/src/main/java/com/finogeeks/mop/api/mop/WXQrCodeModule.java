package com.finogeeks.mop.api.mop;

import android.content.Context;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.modules.callback.FinSimpleCallback;
import com.finogeeks.lib.applet.sdk.model.ParsedAppletInfo;
import com.finogeeks.mop.api.BaseApi;
import com.finogeeks.mop.interfaces.ICallback;

import org.jetbrains.annotations.Nullable;

import java.util.HashMap;
import java.util.Map;

public class WXQrCodeModule extends BaseApi {

    public WXQrCodeModule(Context context) {
        super(context);
    }

    @Override
    public String[] apis() {
        return new String[]{"parseAppletInfoFromWXQrCode"};
    }

    @Override
    public void invoke(String event, Map param, ICallback callback) {
        String qrCode = (String) param.get("qrCode");
        String apiServer = (String) param.get("apiServer");
        FinAppClient.INSTANCE.getAppletApiManager().parseAppletInfoFromWXQrCode(
                qrCode,
                apiServer,
                new FinSimpleCallback<ParsedAppletInfo>() {
                    @Override
                    public void onSuccess(ParsedAppletInfo appletInfo) {
                        HashMap<String, String> map = new HashMap<>();
                        map.put("appId", appletInfo != null ? appletInfo.getAppId() : null);
                        callback.onSuccess(map);
                    }

                    @Override
                    public void onError(int code, @Nullable String error) {
                        callback.onFail(code + ", " + error);
                    }
                });
    }
}
