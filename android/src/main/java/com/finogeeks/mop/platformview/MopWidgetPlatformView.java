package com.finogeeks.mop.platformview;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

import com.finogeeks.lib.applet.client.FinAppClient;
import com.finogeeks.lib.applet.sdk.api.request.IFinAppletRequest;
import com.finogeeks.lib.applet.sdk.component.ComponentCallback;
import com.finogeeks.lib.applet.sdk.component.ComponentHolder;
import com.finogeeks.mop.service.MopPluginService;

/**
 * A simple unified PlatformView which can branch by external viewType.
 * For now, it creates a colored placeholder view; integrate real native views here.
 */
public class MopWidgetPlatformView implements PlatformView {

    private final FrameLayout container;
    @Nullable
    private final Activity activity;
    private final int viewId;

    private static final String TAG = "MOP-PlatformView";

    private ComponentHolder holder;

    public MopWidgetPlatformView(@NonNull Context context,
                                 int viewId,
                                 @NonNull String externalViewType,
                                 @Nullable Map<String, Object> creationParams,
                                 @Nullable Activity activity) {
        this.viewId = viewId;

        this.activity = activity;
        this.container = new FrameLayout(context);
        if ( creationParams != null ) {

           if (creationParams.get("appId") != null) {
               String appId = (String) creationParams.get("appId");
               boolean enableMultiComponent = creationParams.get("enableMultiComponent") != null;
               boolean forceUpdate = creationParams.get("forceUpdate") != null;
               buildContent(context, appId,enableMultiComponent, forceUpdate);
           } else if (creationParams.get("qrCode") != null) {
               String qrCode = (String) creationParams.get("qrCode");
               boolean forceUpdate = creationParams.get("forceUpdate") != null;
               boolean enableMultiComponent = creationParams.get("enableMultiComponent") != null;
               buildContentWithQR(context, qrCode, enableMultiComponent, forceUpdate);
           } else {

                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("errorMessage", "MopWidgetPlatformView: no appId or qrCode found");
                    eventData.put("eventType", "onLoadError");

                    MopPluginService.getInstance().getMopEventStream().send(
                            "platform_view_events",
                            "onLoadError",
                            eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send onError event", e);
                }

               Log.d(TAG, "MopWidgetPlatformView: no appId or qrCode found");
           }

        }
    }

    private void buildContent(Context context, String appId, boolean enableMultiComponent, boolean forceUpdate) {

        IFinAppletRequest request = IFinAppletRequest.Companion.fromAppId(appId)
                .setForceUpdate(forceUpdate);
        request.setEnableMultiComponent(enableMultiComponent);

        FinAppClient.INSTANCE.getAppletApiManager().startComponent((FragmentActivity) activity, request, new ComponentCallback() {
            @Override
            public void onSuccess(@Nullable String s) {
                Log.d(TAG, "onSuccess: $result");
            }

            @Override
            public void onError(int code, @Nullable String error) {
                Log.d(TAG, "onError: " + error);
                
                 // 发送加载失败事件
                 try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("errorMessage", "onError: " + error);
                    eventData.put("eventType", "onLoadError");
                    
                    MopPluginService.getInstance().getMopEventStream().send(
                        "platform_view_events", 
                        "onLoadError", 
                        eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send onLoadError event", e);
                }
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
            public void onContentSizeChanged(int width, int height) {
                Log.d(TAG, "onContentSizeChanged:");
                // 发送内容尺寸变化事件
                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("width", width);
                    eventData.put("height", height);
                    eventData.put("eventType", "contentSizeChanged");
                    
                    MopPluginService.getInstance().getMopEventStream().send(
                        "platform_view_events", 
                        "contentSizeChanged", 
                        eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send contentSizeChanged event", e);
                }
            }

            @Override
            public void onContentLoaded() {
                Log.d(TAG, "onLoad:");
                // 发送内容加载完成事件
                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("message", "widget loaded successfully");
                    eventData.put("eventType", "onContentLoaded");

                    MopPluginService.getInstance().getMopEventStream().send(
                            "platform_view_events",
                            "onContentLoaded",
                            eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send onContentLoaded event", e);
                }
            }
        });

    }


    private void buildContentWithQR( Context context, String qrCode, boolean enableMultiComponent, boolean forceUpdate) {

        IFinAppletRequest request = IFinAppletRequest.Companion.fromQrCode(qrCode)
                .setForceUpdate(forceUpdate);
        request.setEnableMultiComponent(enableMultiComponent);

        FinAppClient.INSTANCE.getAppletApiManager().startComponent((FragmentActivity) activity, request, new ComponentCallback() {
            @Override
            public void onSuccess(@Nullable String s) {
                Log.d(TAG, "onSuccess: $result");
            }

            @Override
            public void onError(int code, @Nullable String error) {
                Log.d(TAG, "onError: " + error);
                // 发送加载失败事件
                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("errorMessage", "onError: " + error);
                    eventData.put("eventType", "onError");

                    MopPluginService.getInstance().getMopEventStream().send(
                            "platform_view_events",
                            "onLoadError",
                            eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send onLoadError event", e);
                }
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
            public void onContentSizeChanged(int width, int height) {
                Log.d(TAG, "onContentSizeChanged:");
                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("width", width);
                    eventData.put("height", height);
                    eventData.put("eventType", "contentSizeChanged");

                    MopPluginService.getInstance().getMopEventStream().send(
                            "platform_view_events",
                            "contentSizeChanged",
                            eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send contentSizeChanged event", e);
                }
            }

            @Override
            public void onContentLoaded() {
                Log.d(TAG, "onLoad:");

                // 发送内容加载完成事件
                try {
                    Map<String, Object> eventData = new HashMap<>();
                    eventData.put("viewId", viewId);
                    eventData.put("message", "widget loaded successfully");
                    eventData.put("eventType", "onContentLoaded");

                    MopPluginService.getInstance().getMopEventStream().send(
                            "platform_view_events",
                            "onContentLoaded",
                            eventData
                    );
                } catch (Exception e) {
                    Log.e(TAG, "Failed to send onContentLoaded event", e);
                }
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
