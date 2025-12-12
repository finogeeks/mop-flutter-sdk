package com.finogeeks.mop.platformview;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.api.request.IFinAppletRequest;
import com.finogeeks.lib.applet.sdk.component.ComponentCallback;
import com.finogeeks.lib.applet.sdk.component.ComponentHolder;

/**
 * A simple unified PlatformView which can branch by external viewType.
 * For now, it creates a colored placeholder view; integrate real native views here.
 */
public class MopWidgetPlatformView implements PlatformView {

    private final FrameLayout container;
    @Nullable
    private final Activity activity;
    private final int viewId;

    private final String externalViewType;
    @Nullable
    private final Map<String, Object> creationParams;
    private static final String TAG = "MOP-PlatformView";

    private ComponentHolder holder;

    public MopWidgetPlatformView(@NonNull Context context,
                                 int viewId,
                                 @NonNull String externalViewType,
                                 @Nullable Map<String, Object> creationParams,
                                 @Nullable Activity activity) {
        this.viewId = viewId;

        this.externalViewType = externalViewType;
        this.creationParams = creationParams;
        this.activity = activity;
        this.container = new FrameLayout(context);
        if ( creationParams != null ) {

           if (creationParams.get("appId") != null) {
               String appId = (String) creationParams.get("appId");
               boolean enableMultiComponent = creationParams.get("enableMultiComponent") != null;
               buildContent(context, appId,enableMultiComponent);
           } else if (creationParams.get("qrCode") != null) {
               String qrCode = (String) creationParams.get("qrCode");
               boolean enableMultiComponent = creationParams.get("enableMultiComponent") != null;
               buildContentWithQR(context, qrCode, enableMultiComponent);
           } else {

               TextView textView = new TextView(context);
               textView.setText("需要传入小组件的 appId 或者小组件的二维码");
               container.addView(
                       textView,
                       new ViewGroup.LayoutParams(
                               FrameLayout.LayoutParams.WRAP_CONTENT,
                               FrameLayout.LayoutParams.WRAP_CONTENT)
               );

               Log.d(TAG, "MopWidgetPlatformView: no appId or qrCode found");
           }

        }
    }

    private void buildContent(Context context, String appId, boolean enableMultiComponent) {
        // TODO: Replace with real native view creation based on externalViewType

        IFinAppletRequest request = IFinAppletRequest.Companion.fromAppId(appId);
        request.setEnableMultiComponent(enableMultiComponent);
        FinAppClient.INSTANCE.getAppletApiManager().startComponent((FragmentActivity) activity, request, new ComponentCallback() {
            @Override
            public void onSuccess(@Nullable String s) {
                Log.d(TAG, "onSuccess: $result");
            }

            @Override
            public void onError(int i, @Nullable String s) {
                Log.d(TAG, "onError: code=$code, error=$error");
                TextView textView = new TextView(context);
                textView.setText("出错啦：" + s);
                container.addView(
                        textView,
                        new ViewGroup.LayoutParams(
                                FrameLayout.LayoutParams.WRAP_CONTENT,
                                FrameLayout.LayoutParams.WRAP_CONTENT)
                );
            }

            @Override
            public void onComponentCreated(@NonNull ComponentHolder componentHolder) {
                holder = componentHolder;
                container.removeAllViews();

                container.addView(
                        holder.getView(),
                        new ViewGroup.LayoutParams(
                                FrameLayout.LayoutParams.MATCH_PARENT,
                                FrameLayout.LayoutParams.MATCH_PARENT));
                container.requestLayout();
                container.invalidate();

            }

            @Override
            public void onContentSizeChanged(int i, int i1) {
                Log.d(TAG, "onContentSizeChanged:");
            }

            @Override
            public void onContentLoaded() {
                Log.d(TAG, "onLoad:");
            }
        });

    }


    private void buildContentWithQR( Context context, String qrCode, boolean enableMultiComponent) {
        // TODO: Replace with real native view creation based on externalViewType

        IFinAppletRequest request = IFinAppletRequest.Companion.fromQrCode(qrCode);
        request.setEnableMultiComponent(enableMultiComponent);
        FinAppClient.INSTANCE.getAppletApiManager().startComponent((FragmentActivity) activity, request, new ComponentCallback() {
            @Override
            public void onSuccess(@Nullable String s) {
                Log.d(TAG, "onSuccess: $result");
            }

            @Override
            public void onError(int i, @Nullable String s) {
                Log.d(TAG, "onError: code=$code, error=$error");
                TextView textView = new TextView(context);
                textView.setText("出错啦：" + s);
                container.addView(
                        textView,
                        new ViewGroup.LayoutParams(
                                FrameLayout.LayoutParams.WRAP_CONTENT,
                                FrameLayout.LayoutParams.WRAP_CONTENT)
                );
            }

            @Override
            public void onComponentCreated(@NonNull ComponentHolder componentHolder) {
                holder = componentHolder;
                container.removeAllViews();

                container.addView(
                        holder.getView(),
                        new ViewGroup.LayoutParams(
                                FrameLayout.LayoutParams.MATCH_PARENT,
                                FrameLayout.LayoutParams.MATCH_PARENT));
                container.requestLayout();
                container.invalidate();

            }

            @Override
            public void onContentSizeChanged(int i, int i1) {
                Log.d(TAG, "onContentSizeChanged:");
            }

            @Override
            public void onContentLoaded() {
                Log.d(TAG, "onLoad:");
            }
        });

    }

    @NonNull
    @Override
    public View getView() {
        Log.d(TAG, "getView: viewId=" + viewId);
        return container;
    }

    @Override
    public void dispose() {
        Log.d(TAG, "dispose: viewId=" + viewId);
        if (holder != null) {
            holder.destroy();
            holder = null;
        }
        container.removeAllViews();

    }
}
