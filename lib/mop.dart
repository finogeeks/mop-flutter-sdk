import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:mop/api.dart';

typedef MopEventCallback = void Function(dynamic event);
typedef MopEventErrorCallback = void Function(dynamic event);

typedef ExtensionApiHandler = Future Function(dynamic params);

class FinStoreConfig {
  String sdkKey; //创建应用时生成的SDK Key
  String sdkSecret; //创建应用时生成的SDK secret
  String apiServer; //服务器地址，客户部署的后台地址

  String apmServer; //apm统计服务器的地址,如果不填，则默认与apiServer一致
  int cryptType; //网络接口加密类型，默认为MD5 0:MD5 1:国密MD5
  String fingerprint; //SDK指纹 证联环境(https://open.fdep.cn/) 时必填，其他环境的不用填
  String
      encryptServerData; //是否需要接口加密验证（初始化多服务器时使用）默认为不开启，当设置为YES时开启，接口返回加密数据并处理

}

class FinAppletUIConfig {
  Map<String, dynamic> navigationTitleTextAttributes; //导航栏的标题样式，目前支持了font

}

class Mop {
  static final Mop _instance = new Mop._internal();
  MethodChannel _channel;
  EventChannel _mopEventChannel;
  int eventId = 0;
  List<Map<String, dynamic>> _mopEventQueye = <Map<String, dynamic>>[];

  Map<String, ExtensionApiHandler> _extensionApis = {};

  Map<String, ExtensionApiHandler> _webExtensionApis = {};

  factory Mop() {
    return _instance;
  }

  Mop._internal() {
    print('mop: _internal');
    // init
    _channel = new MethodChannel('mop');
    _channel.setMethodCallHandler(_handlePlatformMethodCall);
    _mopEventChannel = new EventChannel('plugins.mop.finogeeks.com/mop_event');
    _mopEventChannel.receiveBroadcastStream().listen((dynamic value) {
      print('matrix: receiveBroadcastStream $value');
      for (Map m in _mopEventQueye) {
        if (m['event'] == value['event']) {
          m['MopEventCallback'](value['body']);
        }
      }
    }, onError: (dynamic value) {
      // failure(value);
    });
  }

  static Mop get instance => _instance;

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<dynamic> _handlePlatformMethodCall(MethodCall call) async {
    print("_handlePlatformMethodCall: method:${call.method}");
    if (call.method.startsWith("extensionApi:")) {
      final name = call.method.substring("extensionApi:".length);
      final handler = _extensionApis[name];
      if (handler != null) {
        return await handler(call.arguments);
      }
    } else if (call.method.startsWith("webExtentionApi:")) {
      final name = call.method.substring("webExtentionApi:".length);
      final handler = _webExtensionApis[name];
      if (handler != null) {
        return await handler(call.arguments);
      }
    }
  }

  ///
  ///
  /// initialize mop miniprogram engine.
  /// 初始化小程序
  /// [appkey] is required. it can be getted from api.finclip.com
  /// [secret] is required. it can be getted from api.finclip.com
  /// [apiServer] is optional. the mop server address. default is https://mp.finogeek.com
  /// [apiPrefix] is optional. the mop server prefix. default is /api/v1/mop
  /// [cryptType] is optional. cryptType, should be MD5/SM
  /// [disablePermission] is optional.
  ///
  Future<Map> initialize(String appkey, String secret,
      {String apiServer,
      String apiPrefix,
      String cryptType,
      bool disablePermission,
      String userId,
      bool encryptServerData = false,
      bool debug = false,
      bool bindAppletWithMainProcess = false}) async {
    final Map ret = await _channel.invokeMethod('initialize', {
      'appkey': appkey,
      'secret': secret,
      'apiServer': apiServer,
      'apiPrefix': apiPrefix,
      'cryptType': cryptType,
      'disablePermission': disablePermission,
      'userId': userId,
      "encryptServerData": encryptServerData,
      "debug": debug,
      "bindAppletWithMainProcess": bindAppletWithMainProcess
    });
    return ret;
  }

  /// open the miniprogram [appId] from the  mop server.
  /// 打开小程序
  /// [appId] is required.
  /// [path] is miniprogram open path. example /pages/index/index
  /// [query] is miniprogram query parameters. example key1=value1&key2=value2
  /// [sequence] is miniprogram sequence. example 0,1.2.3,4,5...
  /// [apiServer] is optional. the mop server address. default is https://mp.finogeek.com
  /// [apiPrefix] is optional. the mop server prefix. default is /api/v1/mop
  /// [fingerprint] is optional. the mop sdk fingerprint. is nullable
  /// [cryptType] is optional. cryptType, should be MD5/SM
  Future<Map> openApplet(
    final String appId, {
    final String path,
    final String query,
    final int sequence,
    final String apiServer,
    final String apiPrefix,
    final String fingerprint,
    final String cryptType,
    final String scene,
  }) async {
    Map<String, Object> params = {'appId': appId};
    Map param = {};
    if (path != null) param["path"] = path;
    if (query != null) param["query"] = query;
    if (param.length > 0) params["params"] = param;
    if (sequence != null) params["sequence"] = sequence;
    if (apiServer != null) params["apiServer"] = apiServer;
    if (apiPrefix != null) params["apiPrefix"] = apiPrefix;
    if (fingerprint != null) params["fingerprint"] = fingerprint;
    if (cryptType != null) params["cryptType"] = cryptType;
    if (scene != null) param["scene"] = scene;
    final Map ret = await _channel.invokeMethod('openApplet', params);
    return ret;
  }

  ///
  ///  get current using applet
  ///  获取当前正在使用的小程序信息
  ///  {appId,name,icon,description,version,thumbnail}
  ///
  ///
  Future<Map<String, dynamic>> currentApplet() async {
    final ret = await _channel.invokeMapMethod("currentApplet");
    return Map<String, dynamic>.from(ret);
  }

  ///
  /// close all running applets
  /// 关闭当前打开的所有小程序
  ///
  Future closeAllApplets() async {
    return await _channel.invokeMethod("closeAllApplets");
  }

  ///
  /// clear applets cache
  /// 清除缓存的小程序
  ///
  Future clearApplets() async {
    return await _channel.invokeMethod("clearApplets");
  }

  /// 清除指定的小程序本体缓存
  Future removeUsedApplet(String appId) async {
    Map<String, Object> params = {'appId': appId};
    return await _channel.invokeMethod("removeUsedApplet", params);
  }

  ///
  /// 获取运行时版本号
  ///
  Future<String> sdkVersion() async {
    return await _channel
        .invokeMapMethod("sdkVersion")
        .then((value) => value["data"]);
  }

  ///
  /// （扫码后）解密-鉴权-打开小程序
  ///
  Future scanOpenApplet(String info) async {
    Map<String, Object> params = {'info': info};
    return await _channel.invokeMapMethod("scanOpenApplet", params);
  }

  ///
  /// 根据微信QrCode信息解析小程序信息
  ///
  Future<Map<String, dynamic>> parseAppletInfoFromWXQrCode(
      String qrCode, String apiServer) async {
    final ret = await _channel.invokeMapMethod("parseAppletInfoFromWXQrCode",
        {"qrCode": qrCode, "apiServer": apiServer});
    return Map<String, dynamic>.from(ret);
  }

  ///
  /// register handler to provide custom info or behaviour
  /// 注册小程序事件处理
  ///
  void registerAppletHandler(AppletHandler handler) {
    _extensionApis["forwardApplet"] = (params) async {
      handler.forwardApplet(Map<String, dynamic>.from(params));
    };
    _extensionApis["getUserInfo"] = (params) {
      return handler.getUserInfo();
    };
    _extensionApis["getCustomMenus"] = (params) async {
      final res = await handler.getCustomMenus(params["appId"]);
      List<Map<String, dynamic>> list = [];
      res?.forEach((element) {
        Map<String, dynamic> map = Map();
        map["menuId"] = element.menuId;
        map["image"] = element.image;
        map["title"] = element.title;
        map["type"] = element.type;
        list.add(map);
      });
      print("registerAppletHandler getCustomMenus list $list");
      return list;
    };
    _extensionApis["onCustomMenuClick"] = (params) async {
      return handler.onCustomMenuClick(
          params["appId"], params["path"], params["menuId"], params["appInfo"]);
    };
    _extensionApis["appletDidOpen"] = (params) async {
      return handler.appletDidOpen(params["appId"]);
    };
    _channel.invokeMethod("registerAppletHandler");
  }

  ///
  /// register extension api
  /// 注册拓展api
  ///
  void registerExtensionApi(String name, ExtensionApiHandler handler) {
    _extensionApis[name] = handler;
    _channel.invokeMethod("registerExtensionApi", {"name": name});
  }

  /// 获取国密加密
  Future<String> getSMSign(String plainText) async {
    var result =
        await _channel.invokeMapMethod("smsign", {'plainText': plainText});
    var data = result['data']['data'];
    print(data);
    return data;
  }

  /// WKWebView的弹性设置
  void webViewBounces(bool bounces) async {
    await _channel.invokeMapMethod("webViewBounces", {'bounces': bounces});
    return;
  }

  //20211220新增Api

  //配置多个服务器
  Future<void> setFinStoreConfigs(List<FinStoreConfig> configs) async {}

  //定制ui样式
  Future<void> setUiConfig() async {}

  //自定义ua setUiConfig包含设置ua
  Future<void> setCustomWebViewUserAgent(String ua) async {}

  //支持指定服务器，启动参数，支持扫码打开小程序参数 之前已实现 启动参数 扫码打开小程序
  Future<void> startApplet() async {}

  //定时批量更新小程序的数量
  Future<void> setAppletIntervalUpdateLimit(int count) async {}

  //关闭小程序
  Future<void> closeApplet(String appletId, bool animated) async {
    await _channel.invokeMethod(
        "closeApplet", {"appletId": appletId, "animated": animated});
    return;
  }

  //结束小程序 关闭小程序
  Future<void> finishRunningApplet(String appletId, bool animated) async {
    await _channel.invokeMethod(
        "finishRunningApplet", {"appletId": appletId, "animated": animated});
    return;
  }

  //删除小程序 removeUsedApplet? 删掉缓存小程序包
  Future<void> removeApplet(String appletId) async {
    await _channel.invokeMethod("removeApplet", {"appletId": appletId});
    return;
  }

  //设置小程序切换动画 安卓
  Future<void> setActivityTransitionAnim() async {}

  //发送事件给小程序
  Future<void> sendCustomEvent(Map<String, dynamic> eventData) async {
    await _channel.invokeMethod("sendCustomEvent", {"eventData": eventData});
    return;
  }

  //原生调用js
  Future<void> callJS(String eventName, String nativeViewId,
      Map<String, dynamic> eventData) async {
    await _channel.invokeMethod("callJS", {
      "eventName": eventName,
      "nativeViewId": nativeViewId,
      "eventData": eventData
    });
    return;
  }

  //注册h5的拓展接口
  void addWebExtentionApi(String name, ExtensionApiHandler handler) {
    _webExtensionApis[name] = handler;
    _channel.invokeMethod("addWebExtentionApi", {"name": name});
  }
}
