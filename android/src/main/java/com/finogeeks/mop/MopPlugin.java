package com.finogeeks.mop;

import android.content.Intent;
import android.util.Log;

import com.finogeeks.mop.interfaces.Event;
import com.finogeeks.mop.interfaces.FlutterInterface;
import com.finogeeks.mop.interfaces.ICallback;
import com.finogeeks.mop.service.MopPluginService;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** MopPlugin */
public class MopPlugin implements MethodCallHandler {
  private static final String LOG_TAG = MopPlugin.class.getSimpleName();

  private static final String CHANNEL = "mop";
  private PluginRegistry.Registrar registrar;
  private FlutterInterface flutterInterface;
  private MopPluginDelegate delegate;




  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
    final MopPluginDelegate delegate = new MopPluginDelegate(registrar.activity());
    final MopPlugin instance = new MopPlugin(registrar,delegate);
    channel.setMethodCallHandler(instance);
    final EventChannel eventChannel=new EventChannel(registrar.messenger(),"plugins.mop.finogeeks.com/mop_event");
    MopEventStream mopEventStream = new MopEventStream();
    eventChannel.setStreamHandler(mopEventStream);
    MopPluginService.getInstance().initialize(registrar.activity(),mopEventStream);

  }

  MopPlugin(PluginRegistry.Registrar registrar,MopPluginDelegate delegate) {
    this.registrar = registrar;
    this.flutterInterface = new FlutterInterface();
    this.delegate = delegate;
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    registrar.addActivityResultListener(delegate);
    ICallback callback = new ICallback<Object>() {
      @Override
      public void onSuccess(Object data) {
        Map<String,Object> obj = new HashMap<String,Object>();

        obj.put("success",true);
        if (data != null)
          obj.put("data",data);
        obj.put("retMsg","ok");
        result.success(obj);
      }

      @Override
      public void onFail(Object error) {
        Map<String,Object> obj = new HashMap<String,Object>();
        obj.put("success",false);
        obj.put("retMsg",error==null?"":error);
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
    Log.d(LOG_TAG,"mopplugin: invoke " + call.method);
    Event event= new Event(call.method,call.arguments,callback);
    delegate.setEvent(event);
    this.flutterInterface.invokeHandler(event);
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
  }

}
