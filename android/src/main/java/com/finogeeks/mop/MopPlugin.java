package com.finogeeks.mop;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;

import com.finogeeks.mop.interfaces.Event;
import com.finogeeks.mop.interfaces.FlutterInterface;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.platformview.MopWidgetPlatformViewFactory;
import com.finogeeks.mop.service.MopPluginService;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * MopPlugin
 */
public class MopPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private static final String LOG_TAG = MopPlugin.class.getSimpleName();

  private static final String CHANNEL = "mop";
  private static final String EVENT_CHANNEL = "plugins.mop.finogeeks.com/mop_event";

  private final FlutterInterface flutterInterface = new FlutterInterface();
  private final MopPluginDelegate delegate = new MopPluginDelegate();
  private final MopEventStream mopEventStream = new MopEventStream();

  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  private Lifecycle lifecycle;
  private Activity activity;
  // Unified platform view factory to create native views by external viewType
  private MopWidgetPlatformViewFactory platformViewFactory;

  @Override
  public void onMethodCall(MethodCall call, @NonNull final Result result) {
    ICallback<Object> callback = new ICallback<>() {
        @Override
        public void onSuccess(Object data) {
            Map<String, Object> obj = new HashMap<>();

            obj.put("success", true);
            if (data != null)
                obj.put("data", data);
            obj.put("retMsg", "ok");
            result.success(obj);
        }

        @Override
        public void onFail(Object error) {
            Map<String, Object> obj = new HashMap<>();
            obj.put("success", false);
            obj.put("retMsg", error == null ? "" : error);
            result.success(obj);
        }

        @Override
        public void onCancel(Object cancel) {
            result.notImplemented();
        }

        @Override
        public void startActivityForResult(Intent intent, int requestCode) {
            // 如果需要在 Activity 中启动，可以使用当前的 activity
            if (activity != null && intent != null) {
                activity.startActivityForResult(intent, requestCode);
            }
        }
    };
    Log.d(LOG_TAG, "mopplugin: invoke " + call.method);
    Event event = new Event(call.method, call.arguments, callback);
    delegate.setEvent(event);
    this.flutterInterface.invokeHandler(event);
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    // 使用 binding.getBinaryMessenger() 而不是 binding.getFlutterEngine().getDartExecutor()
    methodChannel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
    methodChannel.setMethodCallHandler(this);

    eventChannel = new EventChannel(binding.getBinaryMessenger(), EVENT_CHANNEL);
    eventChannel.setStreamHandler(mopEventStream);

    // Register unified PlatformView factory
    platformViewFactory = new MopWidgetPlatformViewFactory();
    binding.getPlatformViewRegistry()
        .registerViewFactory("com.finogeeks.mop/platform_view", platformViewFactory);

    Log.d(LOG_TAG, "MopPlugin attached to engine");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (methodChannel != null) {
      methodChannel.setMethodCallHandler(null);
      methodChannel = null;
    }
    if (eventChannel != null) {
      eventChannel.setStreamHandler(null);
      eventChannel = null;
    }
    platformViewFactory = null;
    Log.d(LOG_TAG, "MopPlugin detached from engine");
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addActivityResultListener(delegate);
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);

    setServicesFromActivity(binding.getActivity());
    // give activity to platform view factory so it can access FlutterFragmentActivity
    if (platformViewFactory != null) {
      platformViewFactory.setActivity(this.activity);
    }
    Log.d(LOG_TAG, "MopPlugin attached to activity");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
    Log.d(LOG_TAG, "MopPlugin detached from activity for config changes");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
    Log.d(LOG_TAG, "MopPlugin reattached to activity for config changes");
  }

  @Override
  public void onDetachedFromActivity() {
    if (activity != null) {
      activity = null;
    }
    lifecycle = null;
    if (platformViewFactory != null) {
      platformViewFactory.setActivity(null);
    }
    Log.d(LOG_TAG, "MopPlugin detached from activity");
  }

  private void setServicesFromActivity(Activity activity) {
    if (activity == null) {
      Log.w(LOG_TAG, "Cannot set services from null activity");
      return;
    }
    try {
      MopPluginService.getInstance().initialize(activity, mopEventStream, methodChannel);
      Log.d(LOG_TAG, "MopPluginService initialized successfully");
    } catch (Exception e) {
      Log.e(LOG_TAG, "Failed to initialize MopPluginService", e);
    }
  }
}