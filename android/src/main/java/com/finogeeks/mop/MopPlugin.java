package com.finogeeks.mop;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import androidx.lifecycle.Lifecycle;

import com.finogeeks.mop.interfaces.Event;
import com.finogeeks.mop.interfaces.FlutterInterface;
import com.finogeeks.mop.interfaces.ICallback;
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
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

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

  // These are null when not using v2 embedding.
  private FlutterPluginBinding flutterPluginBinding;
  private MethodChannel channel;
  private EventChannel eventChannel;
  private Lifecycle lifecycle;

  /**
   * Plugin registration.
   */
  @SuppressWarnings("deprecation")
  public static void registerWith(Registrar registrar) {
    MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
    MopPluginDelegate delegate = new MopPluginDelegate();
    final MopPlugin plugin = new MopPlugin();
    channel.setMethodCallHandler(plugin);
    registrar.addActivityResultListener(delegate);

    EventChannel eventChannel = new EventChannel(registrar.messenger(), EVENT_CHANNEL);
    final MopEventStream mopEventStream = new MopEventStream();
    eventChannel.setStreamHandler(mopEventStream);
    MopPluginService.getInstance().initialize(registrar.activity(), mopEventStream, channel);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    ICallback callback = new ICallback<Object>() {
      @Override
      public void onSuccess(Object data) {
        Map<String, Object> obj = new HashMap<String, Object>();

        obj.put("success", true);
        if (data != null)
          obj.put("data", data);
        obj.put("retMsg", "ok");
        result.success(obj);
      }

      @Override
      public void onFail(Object error) {
        Map<String, Object> obj = new HashMap<String, Object>();
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

      }
    };
    Log.d(LOG_TAG, "mopplugin: invoke " + call.method);
    Event event = new Event(call.method, call.arguments, callback);
    delegate.setEvent(event);
    this.flutterInterface.invokeHandler(event);
    // if (call.method.equals("getPlatformVersion")) {
    // result.success("Android " + android.os.Build.VERSION.RELEASE);
    // } else {
    // result.notImplemented();
    // }
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    this.flutterPluginBinding = binding;
    channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(), CHANNEL);
    channel.setMethodCallHandler(this);
    EventChannel eventChannel = new EventChannel(binding.getFlutterEngine().getDartExecutor(), EVENT_CHANNEL);
    eventChannel.setStreamHandler(mopEventStream);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    this.flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    binding.addActivityResultListener(delegate);
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    setServicesFromActivity(binding.getActivity());
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    lifecycle = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    binding.addActivityResultListener(delegate);
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    setServicesFromActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    lifecycle = null;
    channel.setMethodCallHandler(null);
  }

  private void setServicesFromActivity(Activity activity) {
    if (activity == null)
      return;
    MopPluginService.getInstance().initialize(activity, mopEventStream, channel);
  }
}
