import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mop/api.dart';

typedef MopEventCallback = void Function(dynamic event);
typedef MopEventErrorCallback = void Function(dynamic event);

typedef ExtensionApiHandler = Future Function(dynamic params);

class FinStoreConfig {
  ///创建应用时生成的SDK Key
  String sdkKey;

  ///创建应用时生成的SDK secret
  String sdkSecret;

  ///服务器地址，客户部署的后台地址
  String apiServer;

  ///apm统计服务器的地址,如果不填，则默认与apiServer一致
  String apmServer;

  ///网络接口加密类型，默认为MD5 国密SM
  String cryptType;

  ///SDK指纹 证联环境(https://open.fdep.cn/) 时必填，其他环境的不用填
  String? fingerprint;

  ///是否需要接口加密验证（初始化多服务器时使用）默认为不开启，当设置为YES时开启，接口返回加密数据并处理
  bool encryptServerData;

  FinStoreConfig(this.sdkKey, this.sdkSecret, this.apiServer, this.apmServer,
      {this.cryptType = "MD5",
      this.fingerprint,
      this.encryptServerData = false});

  Map<String, dynamic> toMap() {
    return {
      "sdkKey": sdkKey,
      "sdkSecret": sdkSecret,
      "apiServer": apiServer,
      "apmServer": apmServer,
      "cryptType": cryptType,
      "fingerprint": fingerprint,
      "encryptServerData": encryptServerData
    };
  }
}

class UIConfig {
  Map<String, dynamic>? navigationTitleTextAttributes; //导航栏的标题样式，目前支持了font

  ///当导航栏为默认导航栏时，是否始终显示返回按钮
  bool isAlwaysShowBackInDefaultNavigationBar = false;

  ///是否清除导航栏导航按钮的背景
  bool isClearNavigationBarNavButtonBackground = false;

  ///是否隐藏"更多"菜单中的"反馈与投诉"菜单入口
  bool isHideFeedbackAndComplaints = false;

  ///是否隐藏"更多"菜单中的"返回首页"菜单入口
  bool isHideBackHome = false;

  ///是否隐藏"更多"菜单中的"转发"按钮
  bool isHideForwardMenu = false;

  /// 加载小程序过程中（小程序Service层还未加载成功，基础库还没有向SDK传递小程序配置信息），是否隐藏导航栏的关闭按钮
  bool hideTransitionCloseButton = false;

  /// 禁用侧滑关闭小程序手势
  bool disableSlideCloseAppletGesture = false;

  /// 胶囊按钮配置
  CapsuleConfig? capsuleConfig;

  FloatWindowConfig? floatWindowConfig;

  //iOS中独有的设置属性
  //小程序里加载H5页面时进度条的颜色 格式 0xFFFFAA00
  int? progressBarColor;

  //是否自适应暗黑模式。如果设置为true，则更多页面、关于等原生页面会随着手机切换暗黑，也自动调整为暗黑模式
  bool autoAdaptDarkMode = true;

  //注入小程序统称appletText字符串，默认为“小程序”。
  String? appletText;

  Map<String, dynamic> toMap() {
    return {
      "navigationTitleTextAttributes": navigationTitleTextAttributes,
      "isAlwaysShowBackInDefaultNavigationBar":
          isAlwaysShowBackInDefaultNavigationBar,
      "isClearNavigationBarNavButtonBackground":
          isClearNavigationBarNavButtonBackground,
      "isHideFeedbackAndComplaints": isHideFeedbackAndComplaints,
      "isHideBackHome": isHideBackHome,
      "isHideForwardMenu": isHideForwardMenu,
      "hideTransitionCloseButton": hideTransitionCloseButton,
      "disableSlideCloseAppletGesture": disableSlideCloseAppletGesture,
      "capsuleConfig": capsuleConfig?.toMap(),
      "floatWindowConfig": floatWindowConfig?.toMap(),
      "progressBarColor": progressBarColor,
      "autoAdaptDarkMode": autoAdaptDarkMode,
      "appletText": appletText
    };
  }
}

/// 胶囊按钮配置
class CapsuleConfig {
  /// 上角胶囊视图的宽度，默认值为88
  double capsuleWidth = 88;

  ///上角胶囊视图的高度，默认值为32
  double capsuleHeight = 32;

  ///右上角胶囊视图的右边距
  double capsuleRightMargin = 7;

  ///右上角胶囊视图的圆角半径，默认值为5
  double capsuleCornerRadius = 5;

  ///右上角胶囊视图的边框宽度，默认值为0.8
  double capsuleBorderWidth = 1;

  ///胶囊背景颜色浅色
  int capsuleBgLightColor = 0x33000000;

  ///胶囊背景颜色深色
  int capsuleBgDarkColor = 0x80ffffff;

  /// 右上角胶囊视图的边框浅色颜色

  int capsuleBorderLightColor = 0x80ffffff;

  ///右上角胶囊视图的边框深色颜色

  int capsuleBorderDarkColor = 0x26000000;

  ///胶囊分割线浅色颜色
  int capsuleDividerLightColor = 0x80ffffff;

  ///胶囊分割线深色颜色
  int capsuleDividerDarkColor = 0x26000000;

  ///胶囊里的浅色更多按钮的图片对象，如果不传，会使用默认图标
  int? moreLightImage;

  ///胶囊里的深色更多按钮的图片对象，如果不传，会使用默认图标
  int? moreDarkImage;

  ///胶囊里的更多按钮的宽度，高度与宽度相等
  double moreBtnWidth = 32;

  ///胶囊里的更多按钮的左边距
  double moreBtnLeftMargin = 6;

  ///胶囊里的浅色更多按钮的图片对象，如果不传，会使用默认图标

  int? closeLightImage;

  ///胶囊里的深色更多按钮的图片对象，如果不传，会使用默认图标
  int? closeDarkImage;

  ///胶囊里的关闭按钮的宽度，高度与宽度相等
  double closeBtnWidth = 32;

  ///胶囊里的关闭按钮的左边距
  double closeBtnLeftMargin = 6;

  Map<String, dynamic> toMap() {
    return {
      "capsuleWidth": capsuleWidth,
      "capsuleHeight": capsuleHeight,
      "capsuleRightMargin": capsuleRightMargin,
      "capsuleCornerRadius": capsuleCornerRadius,
      "capsuleBorderWidth": capsuleBorderWidth,
      "capsuleBgLightColor": capsuleBgLightColor,
      "capsuleBgDarkColor": capsuleBgDarkColor,
      "capsuleBorderLightColor": capsuleBorderLightColor,
      "capsuleBorderDarkColor": capsuleBorderDarkColor,
      "capsuleDividerLightColor": capsuleDividerLightColor,
      "capsuleDividerDarkColor": capsuleDividerDarkColor,
      "moreLightImage": moreLightImage,
      "moreDarkImage": moreDarkImage,
      "moreBtnWidth": moreBtnWidth,
      "moreBtnLeftMargin": moreBtnLeftMargin,
      "closeLightImage": closeLightImage,
      "closeDarkImage": closeDarkImage,
      "closeBtnWidth": closeBtnWidth,
      "closeBtnLeftMargin": closeBtnLeftMargin,
    };
  }
}

class FloatWindowConfig {
  bool floatMode = false;
  int x;
  int y;
  int width;
  int height;

  FloatWindowConfig(this.floatMode, this.x, this.y, this.width, this.height);

  Map<String, dynamic> toMap() {
    return {
      "floatMode": floatMode,
      "x": x,
      "y": y,
      "width": width,
      "height": height
    };
  }
}

class BaseAppletRequest {
  // 服务器地址，必填
  String apiServer;
  // 小程序id，必填
  String appletId;
  // 小程序的启动参数，非必填
  Map<String, String>? startParams;
  // iOS端打开小程序时是否显示动画，默认为true。
  bool? animated;

  BaseAppletRequest({
    required this.apiServer, 
    required this.appletId,
    this.startParams,
    this.animated = true,
    });

  Map<String, dynamic> toMap() {
    return {
      "apiServer": apiServer,
      "appletId": appletId,
      "startParams": startParams,
      "animated": animated
    };
  }
}

class RemoteAppletRequest {
  // 服务器地址，必填
  String apiServer;
  // 小程序id，必填
  String appletId;
  // 小程序的启动参数，非必填
  Map<String, String>? startParams;
  // 小程序的索引，（审核小程序时必填）
  int? sequence;
  // 离线小程序压缩包路径，非必填
  String? offlineMiniprogramZipPath;
  // 离线基础库压缩包路径，非必填
  String? offlineFrameworkZipPath;
  // iOS端打开小程序时是否显示动画，默认为true。
  bool animated;

  RemoteAppletRequest({
    required this.apiServer, 
    required this.appletId,
    this.startParams,
    this.sequence,
    this.offlineMiniprogramZipPath,
    this.offlineFrameworkZipPath,
    this.animated = true,
    });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      "apiServer": apiServer,
      "appletId": appletId,
      "animated": animated
    };
    if (startParams != null) result["startParams"] = startParams;
    if (offlineMiniprogramZipPath != null) result["offlineMiniprogramZipPath"] = offlineMiniprogramZipPath;
    if (offlineFrameworkZipPath != null) result["offlineFrameworkZipPath"] = offlineFrameworkZipPath;
    if (sequence != null) result["sequence"] = sequence;

    return result;
  }
}

class QRCodeAppletRequest {
  // 二维码内容
  String qrCode;
  // 是否显示打开动画
  bool animated = true;

  QRCodeAppletRequest(this.qrCode);

  Map<String, dynamic> toMap() {
    return {
      "apiServer": qrCode,
      "animated": animated
    };
  }
}

enum Anim {
  SlideFromLeftToRightAnim,
  SlideFromRightToLeftAnim,
  SlideFromTopToBottomAnim,
  SlideFromBottomToTopAnim,
  FadeInAnim,
  NoneAnim
}

class Mop {
  static final Mop _instance = new Mop._internal();
  late MethodChannel _channel;
  late EventChannel _mopEventChannel;
  late int eventId = 0;
  final List<Map<String, dynamic>> _mopEventQueye = <Map<String, dynamic>>[];

  final Map<String, ExtensionApiHandler> _extensionApis = {};

  Map<String, ExtensionApiHandler> _webExtensionApis = {};

  factory Mop() {
    return _instance;
  }

  Mop._internal() {
    debugPrint('mop: _internal');
    // init
    _channel = const MethodChannel('mop');
    _channel.setMethodCallHandler(_handlePlatformMethodCall);
    _mopEventChannel =
        const EventChannel('plugins.mop.finogeeks.com/mop_event');
    _mopEventChannel.receiveBroadcastStream().listen((dynamic value) {
      debugPrint('matrix: receiveBroadcastStream $value');
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
    debugPrint("_handlePlatformMethodCall: method:${call.method}");
    if (call.method.startsWith("extensionApi:")) {
      final name = call.method.substring("extensionApi:".length);
      final handler = _extensionApis[name];
      debugPrint("name:$name,handler:$handler");
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
  /// [sdkkey] is required. it can be getted from api.finclip.com
  /// [secret] is required. it can be getted from api.finclip.com
  /// [apiServer] is optional. the mop server address. default is https://mp.finogeek.com
  /// [apiPrefix] is optional. the mop server prefix. default is /api/v1/mop
  /// [cryptType] is optional. cryptType, should be MD5/SM
  /// [disablePermission] is optional.
  /// [encryptServerData] 是否对服务器数据进行加密，需要服务器支持
  /// [userId] 用户id
  /// [finStoreConfigs] 多服务配置
  /// [uiConfig] UI配置
  /// [debug] 设置debug模式，影响调试和日志
  /// [customWebViewUserAgent] 设置自定义webview ua
  /// [appletIntervalUpdateLimit] 设置小程序批量更新周期
  /// [maxRunningApplet] 设置最大同时运行小程序个数
  ///
  Future<Map> initialize(
    String sdkkey,
    String secret, {
    String? apiServer,
    String? apiPrefix,
    String? cryptType,
    bool encryptServerData = false,
    bool disablePermission = false,
    String? userId,
    bool debug = false,
    bool bindAppletWithMainProcess = false,
    int? pageCountLimit = 0,
    List<FinStoreConfig>? finStoreConfigs,
    UIConfig? uiConfig,
    String? customWebViewUserAgent,
    int? appletIntervalUpdateLimit,
    int? maxRunningApplet,
  }) async {
    List<Map<String, dynamic>>? storeConfigs =
        finStoreConfigs?.map((e) => e.toMap()).toList();

    final Map ret = await _channel.invokeMethod('initialize', {
      'appkey': sdkkey,
      'secret': secret,
      'apiServer': apiServer,
      'apiPrefix': apiPrefix,
      'cryptType': cryptType,
      "encryptServerData": encryptServerData,
      'disablePermission': disablePermission,
      'userId': userId,
      "debug": debug,
      "bindAppletWithMainProcess": bindAppletWithMainProcess,
      "pageCountLimit": pageCountLimit,
      "finStoreConfigs": storeConfigs,
      "uiConfig": uiConfig?.toMap(),
      "customWebViewUserAgent": customWebViewUserAgent,
      "appletIntervalUpdateLimit": appletIntervalUpdateLimit,
      "maxRunningApplet": maxRunningApplet
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
    final String? path,
    final String? query,
    final int? sequence,
    final String? apiServer,
    final String? scene,
  }) async {
    Map<String, Object> params = {'appId': appId};
    Map param = {};
    if (path != null) param["path"] = path;
    if (query != null) param["query"] = query;
    if (param.length > 0) params["params"] = param;
    if (sequence != null) params["sequence"] = sequence;
    if (apiServer != null) params["apiServer"] = apiServer;
    if (scene != null) param["scene"] = scene;
    final Map ret = await _channel.invokeMethod('openApplet', params);
    return ret;
  }

  
  Future<Map> startApplet(RemoteAppletRequest request) async {
    Map<String, dynamic> params = request.toMap();
    final Map ret = await _channel.invokeMethod('startApplet', params);
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
    return Map<String, dynamic>.from(ret!);
  }

  Future<Map<String, dynamic>> changeUserId(String userId) async {
    Map<String, Object> params = {'userId': userId};
    final ret = await _channel.invokeMapMethod("changeUserId", params);
    return Map<String, dynamic>.from(ret!);
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

  /// 清除所有小程序缓存
  Future removeAllUsedApplets() async {
    Map<String, Object> params = {};
    return await _channel.invokeMethod("removeAllUsedApplets", params);
  }

  ///
  /// 获取运行时版本号
  ///
  Future<String> sdkVersion() async {
    return await _channel
        .invokeMapMethod("sdkVersion")
        .then((value) => value?["data"]);
  }

  ///
  /// （扫码后）解密-鉴权-打开小程序
  ///
  Future scanOpenApplet(String info) async {
    Map<String, Object> params = {'info': info};
    return await _channel.invokeMapMethod("scanOpenApplet", params);
  }

  ///
  /// 通过二维码打开小程序
  /// [qrcode] 二维码内容
  ///
  Future qrcodeOpenApplet(String qrcode) async {
    Map<String, Object> params = {'qrcode': qrcode};
    return await _channel.invokeMapMethod("qrcodeOpenApplet", params);
  }

  ///
  /// 根据微信QrCode信息解析小程序信息
  ///
  Future<Map<String, dynamic>> parseAppletInfoFromWXQrCode(
      String qrCode, String apiServer) async {
    final ret = await _channel.invokeMapMethod("parseAppletInfoFromWXQrCode",
        {"qrCode": qrCode, "apiServer": apiServer});
    return Map<String, dynamic>.from(ret!);
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
      res.forEach((element) {
        Map<String, dynamic> map = Map();
        map["menuId"] = element.menuId;
        map["image"] = element.image;
        map["title"] = element.title;
        map["type"] = element.type;
        list.add(map);
      });
      debugPrint("registerAppletHandler getCustomMenus list $list");
      return list;
    };
    _extensionApis["onCustomMenuClick"] = (params) async {
      return handler.onCustomMenuClick(
          params["appId"], params["path"], params["menuId"], params["appInfo"]);
    };
    _extensionApis["appletDidOpen"] = (params) async {
      return handler.appletDidOpen(params["appId"]);
    };
    _extensionApis["getPhoneNumber"] = (params) async {
      return handler.getMobileNumber((params0) =>
          {_channel.invokeMethod("getPhoneNumberResult", params0)});
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
    var data = result?['data']['data'];
    debugPrint(data);
    return data;
  }

  /// WKWebView的弹性设置
  void webViewBounces(bool bounces) async {
    await _channel.invokeMapMethod("webViewBounces", {'bounces': bounces});
    return;
  }

  ///
  /// 关闭小程序 小程序会在内存中存在
  ///
  Future<void> closeApplet(String appletId, bool animated) async {
    await _channel.invokeMethod(
        "closeApplet", {"appletId": appletId, "animated": animated});
    return;
  }

  ///
  /// 结束小程序 小程序会从内存中清除
  ///
  Future<void> finishRunningApplet(String appletId, bool animated) async {
    await _channel.invokeMethod(
        "finishRunningApplet", {"appletId": appletId, "animated": animated});
    return;
  }

  ///
  /// 设置小程序切换动画 安卓
  ///
  Future setActivityTransitionAnim(Anim anim) async {
    await _channel
        .invokeMethod("setActivityTransitionAnim", {"anim": anim.name});
    return;
  }

  ///
  /// 原生发送事件给小程序
  /// [appId] 小程序id
  /// [eventData] 事件对象
  Future<void> sendCustomEvent(
      String appId, Map<String, dynamic> eventData) async {
    await _channel.invokeMethod(
        "sendCustomEvent", {"appId": appId, "eventData": eventData});
    return;
  }

  ///
  /// 原生调用webview中的js方法
  /// [appId] 小程序id
  /// [eventName] 方法名
  /// [nativeViewId] webviewId
  /// [eventData] 参数
  ///
  Future<void> callJS(String appId, String eventName, String nativeViewId,
      Map<String, dynamic> eventData) async {
    await _channel.invokeMethod("callJS", {
      "appId": appId,
      "eventName": eventName,
      "nativeViewId": nativeViewId,
      "eventData": eventData
    });
    return;
  }

  ///
  /// register webview extension api
  /// 注册webview拓展api
  ///
  void addWebExtentionApi(String name, ExtensionApiHandler handler) {
    _webExtensionApis[name] = handler;
    _channel.invokeMethod("addWebExtentionApi", {"name": name});
  }
}
