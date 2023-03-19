import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mop/api.dart';

typedef MopEventCallback = void Function(dynamic event);
typedef MopEventErrorCallback = void Function(dynamic event);

typedef ExtensionApiHandler = Future<Map<String, dynamic>> Function(
    dynamic params);
typedef MopAppletHandler = Future Function(dynamic params);

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

class FATConfig {
  /**
 当前用户id，对应管理后台的用户管理->成员管理->用户id。
 若体验版本配置了体验成员，则需要设置正确的userId才能具备打开小程序的权限
 登录/切换用户/退出登录时，需要修改此值。
 小程序缓存信息会存储在以userId命名的不同目录下。
 */
String? currentUserId;

/**
 产品的标识，非必传，默认为存储目录里的finclip，finogeeks和userAgent里的finogeeks
 */
String? productIdentification;

/**
是否不让SDK申请权限
如果设置为true，则SDK内使用权限的api，不会主动申请权限
*/
bool disableAuthorize = false;

/**
 小程序自动申请授权
 如果设置为true，则小程序申请权限时不会弹出用户确认提示框
 */
bool appletAutoAuthorize = false;

/**
 是否禁用SDK的监管接口API（默认开启：false）
 如果设置为true，则SDK禁用监管接口API
*/
bool disableGetSuperviseInfo = false;

/**
 是否忽略webview的证书校验，默认为false,进行校验
 如果设置为true，则忽略校验Https的证书
*/
bool ignoreWebviewCertAuth = false;

/**
后台自动检查更新的小程序个数
初始化SDK成功后，如处于wifi网络下，更新最近使用的x个小程序
取值范围：0~50。0代表不检查更新；不设置默认是3。
*/
int appletIntervalUpdateLimit = 3;

/**
apm 统计的扩展信息
*/
Map<String,String>? apmExtension;

/** 是否开启Crash防崩溃，默认为false。(iOS支持)
 如果开启，可以防止如下类型的崩溃：UnrecognizedSelector、KVO、Notification、Timer、Container(数组越界，字典插入nil等)、String (越界、nil等)
 如果在开发阶段，建议关闭该属性，否则开发时不便于及时发现代码中的崩溃问题。
*/
bool startCrashProtection = false;

Map? theme;

/**
 * 数据上报时，是否压缩请求的数据
 * 默认为false
 */
bool enableApmDataCompression = false;

/**
是否需要接口加密验证（初始化单服务器时使用）
默认为不开启，当设置为YES时开启，接口返回加密数据并处理
*/
bool encryptServerData = false;

/**
 是否开启小程序的debug模式。
 默认为FATBOOLStateUndefined，此时为旧版通过app.json 中 debug:true 开启vconsole。
 当设置为FATBOOLStateTrue时，强制所有的小程序都会开启vconsole。
 当设置为FATBOOLStateFalse时，非正式版会在更多菜单里显示打开和关闭调试的菜单。
 当设置为FATBOOLStateForbidden时，所有版本强制关闭vconsole，且不可调api开启，多面板不展示打开、关闭调试菜单
 */
@property (nonatomic, assign) FATBOOLState enableAppletDebug;

/**
 是否显示水印
 */
bool enableWatermark = false;

/**
 显示水印优先级设置，默认全局配置优先
 */
ConfigPriority watermarkPriority = ConfigPriority.ConfigGlobalPriority;

/**
 小程序的自定义启动加载页，非必填。
 自定义启动加载页必须继承自FATBaseLoadingView
 注意：swift中的类名带有命名空间，需要在前拼接项目文件名，如：“SwiftDemo.FCloadingView”。其中SwiftDemo是项目名，FCloadingView是类名
*/
String? baseLoadingViewClass;

/**
 小程序的自定义启动失败页，非必填。
 自定义启动失败页必须继承自FATBaseLoadFailedView
 注意：swift中的类名带有命名空间，需要在前拼接项目文件名，如：“SwiftDemo.FCloadingView”。其中SwiftDemo是项目名，FCloadingView是类名
*/
String? baseLoadFailedViewClass;

/**
 统一设置小程序中网络请求的header。
 注意，如果小程序调用api时也传递了相同的key，则会用小程序传递的参数覆盖。
 对ft.request、ft.downloadFile、ft.uploadFile均会生效
 */
Map<String,dynamic>? header;

/**
 header优先级设置，默认全局配置优先
 */
ConfigPriority headerPriority = ConfigPriority.ConfigGlobalPriority;

/**
 是否开启小程序中加载的H5页面hook功能，非必填。
 如果宿主app 拦截了http 或https，会导致H5中的request 丢失body。我们SDK为了兼容这一问题，会hook request请求，
 在发起请求之前，先将body中的参数，通过代理方法传递给宿主App。宿主App可自行存储每个request的body，然后在
 自定义的URLProtocol里发起请求之前，组装上body内容。
 */
bool enableH5AjaxHook = false;

/**
 开启enableH5AjaxHook后，会hook request请求，会在原request 的url 后拼上一个FinClipHookBridge-RequestId=xxx的参数。
 而该参数可设置参数名，比如您可以设置Key 为 FinClip-RequestId，这样会拼接FinClip-RequestId=xxx的参数。
 */
String? h5AjaxHookRequestKey;

/**
 小程序中页面栈的最大限制。默认值为0，标识不限制。
 例如，设置为5，则表示页面栈中最多可有5个页面。从主页最多可再navigateTo 4 层页面。
 */
int pageCountLimit = 0;

/**
 自定义的scheme数组
 */
List<String> schemes = [];

   Map<String, dynamic> toMap() {
    return {
      "currentUserId": currentUserId,
      "productIdentification": productIdentification,

      "disableAuthorize": disableAuthorize,
      "appletAutoAuthorize": appletAutoAuthorize,
      "disableGetSuperviseInfo": disableGetSuperviseInfo,
      "ignoreWebviewCertAuth": ignoreWebviewCertAuth,
      "appletIntervalUpdateLimit": appletIntervalUpdateLimit,
      "apmExtension": apmExtension,
      "enableApmDataCompression": enableApmDataCompression,
      "encryptServerData": encryptServerData,
      "enableAppletDebug": enableAppletDebug,
      "enableWatermark": enableWatermark,
      "watermarkPriority": watermarkPriority.index,
      "baseLoadingViewClass": baseLoadingViewClass,
      "baseLoadFailedViewClass": baseLoadFailedViewClass,
      "header": header,
      "headerPriority": headerPriority.index,
      "enableH5AjaxHook": enableH5AjaxHook,
      "pageCountLimit": pageCountLimit,
      "schemes": schemes,
    };
   }
}

class UIConfig {
  Map<String, dynamic>? navigationTitleTextAttributes; //导航栏的标题样式，目前支持了font

  //导航栏的高度(不含状态栏高度)，默认值为44
  double navigationBarHeight = 44;

  //导航栏的标题颜色（深色主题），默认值为白色
  int navigationBarTitleLightColor = 0xffffffff;

  //导航栏的标题颜色（明亮主题），默认值为黑色
  int navigationBarTitleDarkColor = 0xff000000;

  //导航栏的返回按钮颜色（深色主题），默认值为白色
  int navigationBarBackBtnLightColor = 0xffffffff;

  //导航栏的返回按钮颜色（明亮主题），默认值为黑色
  int navigationBarBackBtnDarkColor 0xff000000;

  // int? navigationBackImage;
  //弹出的菜单视图的样式 0:默认 1:
  int moreMenuStyle = 0;

  //隐藏导航栏返回首页按钮的优先级设置，默认全局配置优先 不支持FATConfigAppletFilePriority
  ConfigPriority hideBackToHomePriority = ConfigPriority.ConfigGlobalPriority

  ///当导航栏为默认导航栏时，是否始终显示返回按钮
  bool isAlwaysShowBackInDefaultNavigationBar = false;

  ///是否清除导航栏导航按钮的背景
  bool isClearNavigationBarNavButtonBackground = false;

  ///是否隐藏"更多"菜单中的"反馈与投诉"菜单入口
  bool isHideFeedbackAndComplaints = false;

  ///是否隐藏"更多"菜单中的"返回首页"菜单入口
  bool isHideBackHome = false;

  //隐藏...弹出菜单中的 【转发】 的菜单，默认为false
  bool isHideForwardMenu = false;

  //隐藏...弹出菜单中的 【反馈与投诉】 的菜单，默认为false
  bool isHideFeedbackMenu = false;

  //隐藏...弹出菜单中的 【分享】 的菜单，默认为true
  bool isHideShareAppletMenu = true;

  //隐藏...弹出菜单中的 【重新进入小程序】 的菜单，默认为false
  bool isHideRefreshMenu = false;

  //隐藏...弹出菜单中的 【设置】 的菜单，默认为false
  bool isHideSettingMenu = false;

  /// 加载小程序过程中（小程序Service层还未加载成功，基础库还没有向SDK传递小程序配置信息），是否隐藏导航栏的关闭按钮
  bool hideTransitionCloseButton = false;

  /// 禁用侧滑关闭小程序手势
  bool disableSlideCloseAppletGesture = false;

  /// 胶囊按钮配置
  CapsuleConfig? capsuleConfig;

  //返回首页按钮的配置
  NavHomeConfig? navHomeConfig;

  FloatWindowConfig? floatWindowConfig;

  //权限弹窗UI配置
  AuthViewConfig? authViewConfig;

  //iOS中独有的设置属性
  //小程序里加载H5页面时进度条的颜色 格式 0xFFFFAA00
  int? progressBarColor;

  //隐藏小程序里加载H5时进度条，默认为false
  bool hideWebViewProgressBar = false;

  

  //是否自适应暗黑模式。如果设置为true，则更多页面、关于等原生页面会随着手机切换暗黑，也自动调整为暗黑模式
  bool autoAdaptDarkMode = true;

  //要拼接的userAgent字符串
  String? appendingCustomUserAgent;
  /**
 打开小程序时的默认动画方式，默认为FATTranstionStyleUp。
 该属性主要针对非api方式打开小程序时的动画缺省值。主要改变如下场景的动画方式：
 1. scheme 打开小程序；
 2. universal link 打开小程序；
 3. navigateToMiniprogram
 */
  TranstionStyle transtionStyle = TranstionStyle.TranstionStyleUp;

  //是否隐藏转场页的关闭按钮。默认为false
  bool hideTransitionCloseButton = false;

  /**
 是否禁用侧滑关闭小程序的手势。默认为NO
 该手势禁用，不影响小程序里页面的侧滑返回上一页的功能
 */
  bool disableSlideCloseAppletGesture = false;

  //注入小程序统称appletText字符串，默认为“小程序”。
  String? appletText;

  Map<String, dynamic> toMap() {
    return {
      "navigationTitleTextAttributes": navigationTitleTextAttributes,
      "navigationBarHeight": navigationBarHeight,
      "navigationBarTitleLightColor": navigationBarTitleLightColor,
      "navigationBarTitleDarkColor": navigationBarTitleDarkColor,
      "navigationBarBackBtnLightColor": navigationBarBackBtnLightColor,
      "navigationBarBackBtnDarkColor": navigationBarBackBtnDarkColor,
      "isAlwaysShowBackInDefaultNavigationBar":
          isAlwaysShowBackInDefaultNavigationBar,
      "isClearNavigationBarNavButtonBackground":
          isClearNavigationBarNavButtonBackground,
      "isHideFeedbackAndComplaints": isHideFeedbackAndComplaints,
      "isHideBackHome": isHideBackHome,
      "isHideForwardMenu": isHideForwardMenu,
      "isHideRefreshMenu": isHideRefreshMenu,
      "isHideFeedbackMenu": isHideFeedbackMenu,
      "isHideShareAppletMenu": isHideShareAppletMenu,
      "isHideSettingMenu": isHideSettingMenu,
      "hideTransitionCloseButton": hideTransitionCloseButton,
      "disableSlideCloseAppletGesture": disableSlideCloseAppletGesture,
      "capsuleConfig": capsuleConfig?.toMap(),
      "navHomeConfig": navHomeConfig?.toMap(),
      "authViewConfig": authViewConfig,toMap(,)
      "floatWindowConfig": floatWindowConfig?.toMap(),
      "progressBarColor": progressBarColor,
      "hideWebViewProgressBar": hideWebViewProgressBar,
      "moreMenuStyle": moreMenuStyle,
      "hideBackToHomePriority": hideBackToHomePriority,
      "autoAdaptDarkMode": autoAdaptDarkMode,
      "appendingCustomUserAgent": appendingCustomUserAgent,
      "transtionStyle":transtionStyle.index,
      "hideTransitionCloseButton": hideTransitionCloseButton,
      "disableSlideCloseAppletGesture": disableSlideCloseAppletGesture,
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

class NavHomeConfig {
  /**
 返回首页按钮的宽度
 */
  double width;

/**
 返回首页按钮的高度
 */
  double height;

/**
 返回首页按钮的左边距，默认值为10
 */
  double leftMargin;

/**
 返回首页按钮的圆角半径，默认值为5
 */
  double cornerRadius;

/**
 返回首页按钮的边框宽度，默认值为0.8
 */
  double borderWidth;

/**
 浅色返回首页按钮的图片对象，如果不传，会使用默认图标
 （暗黑模式）
*/
//  int? lightImage;

/**
 深色返回首页按钮的图片对象，如果不传，会使用默认图标
 （明亮模式）
*/
// int? darkImage;

/**
 返回首页按钮的边框浅色颜色
 （暗黑模式）
 */
  int borderLightColor;

/**
 返回首页按钮的边框深色颜色
 （明亮模式）
 */
  int borderDarkColor;

/**
 返回首页按钮的背景浅色颜色
 （明亮模式）
 */
  int bgLightColor;

/**
 返回首页按钮的背景深色颜色
 （暗黑模式）
 */
  int bgDarkColor;

  Map<String, dynamic> toMap() {
    return {
      "width": width,
      "height": height,
      "leftMargin": leftMargin,
      "cornerRadius": cornerRadius,
      "borderWidth": borderWidth,
      "borderLightColor": borderLightColor,
      "borderDarkColor": borderDarkColor,
      "bgLightColor": bgLightColor,
      "bgDarkColor": bgDarkColor,
    };
  }
}

class AuthViewConfig {
/**
 小程序名称字体大小，默认字体为PingFangSC-Regular，默认大小16
 */
int appletNameFont;

/**
 小程序名称的浅色颜色（明亮模式），默认#202020
 */
int appletNameLightColor;

/**
 小程序名称的深色颜色（暗黑模式），默认#D0D0D0
 */
int appletNameDarkColor;

/**
 隐私协议入口icon（明亮模式），大小：22pt（@2× @3×）
 */
int agreementLightImage;

/**
 隐私协议入口icon（暗黑模式），大小：22pt（@2× @3×）
 */
int agreementDarkImage;

/**
 权限标题字体大小，默认字体为PingFangSC-Medium，默认大小17
 备注：权限选项文字字体大小使用该配置项，但字体固定为PingFangSC-Regular
 */
int authorizeTitleFont;

/**
 权限标题的浅色颜色（明亮模式），默认#202020
 备注：权限选项文字字体颜色使用该配置项
 */
int authorizeTitleLightColor;

/**
 权限标题的深色颜色（暗黑模式），默认#D0D0D0
 备注：权限选项文字字体颜色使用该配置项
 */
int authorizeTitleDarkColor;

/**
 权限描述字体大小，默认字体为PingFangSC-Regular，默认大小14
 */
int authorizeDescriptionFont;

/**
 权限描述的浅色颜色（明亮模式），默认#666666
 */
int authorizeDescriptionLightColor;

/**
 权限描述的深色颜色（暗黑模式），默认#8C8C8C
 */
int authorizeDescriptionDarkColor;

/**
 协议标题字体大小，默认字体为PingFangSC-Regular，默认大小16
 */
int agreementTitleFont;

/**
 协议标题的浅色颜色（明亮模式），默认#202020
 */
int agreementTitleLightColor;

/**
 协议标题的深色颜色（暗黑模式），默认#D0D0D0
 */
int agreementTitleDarkColor;

/**
 协议描述字体大小，默认字体为PingFangSC-Regular，默认大小14
 */
int agreementDescriptionFont;

/**
 协议描述的浅色颜色（明亮模式），默认#202020
 */
int agreementDescriptionLightColor;

/**
 协议描述的深色颜色（暗黑模式），默认#D0D0D0
 */
int agreementDescriptionDarkColor;

/**
 权限选项选中时的icon（明亮模式），大小：22pt（@2× @3×）
 */
int authorizeSelectedLightImage;

/**
 权限选项选中时的icon（暗黑模式），大小：22pt（@2× @3×）
 */
int authorizeSelectedDarkImage;

/**
 链接的浅色颜色（明亮模式），默认#409EFF
 */
int linkLightColor;

/**
 链接的深色颜色（暗黑模式），默认#368CE4
 */
int linkDarkColor;

/**
 同意按钮配置（明亮模式），默认配置如下：
 圆角：4
 默认背景色：#4285F4
 默认描边：#4285F4
 默认文字颜色：#FFFFFF
 按下背景色：#3B77DB
 按下默认描边：#3B77DB
 按下文字颜色：#FFFFFF
 */
AuthButtonConfig allowButtonLightConfig;

/**
 同意按钮配置（暗黑模式），默认配置如下：
 圆角：4
 默认背景色：#4285F4
 默认描边：#4285F4
 默认文字颜色：#FFFFFF
 按下背景色：#5E97F5
 按下默认描边：#5E97F5
 按下文字颜色：#FFFFFF
 */
AuthButtonConfig allowButtonDarkConfig;

/**
 拒绝按钮配置（明亮模式），默认配置如下：
 圆角：4
 默认背景色：#FFFFFF
 默认描边：#E2E2E2
 默认文字颜色：#222222
 按下背景色：#D8D8D8
 按下默认描边：#D8D8D8
 按下文字颜色：#222222
 */
AuthButtonConfig rejectButtonLightConfig;

/**
 拒绝按钮配置（暗黑模式），默认配置如下：
 圆角：4
 默认背景色：#2C2C2C
 默认描边：#2C2C2C
 默认文字颜色：#D0D0D0
 按下背景色：#414141
 按下默认描边：#414141
 按下文字颜色：#D0D0D0
 */
AuthButtonConfig rejectButtonDarkConfig;

Map<String, dynamic> toMap() {
    return {
      "appletNameFont": appletNameFont,
      "appletNameLightColor": appletNameLightColor,
      "appletNameDarkColor": appletNameDarkColor,
      "authorizeTitleFont": authorizeTitleFont,
      "authorizeTitleLightColor": authorizeTitleLightColor,
      "authorizeTitleDarkColor": authorizeTitleDarkColor,
      "authorizeDescriptionFont": authorizeDescriptionFont,
      "authorizeDescriptionLightColor": authorizeDescriptionLightColor,
      "authorizeDescriptionDarkColor": authorizeDescriptionDarkColor,

      "agreementTitleFont": agreementTitleFont,
      "agreementTitleLightColor": agreementTitleLightColor,
      "agreementTitleDarkColor": agreementTitleDarkColor,
      "agreementDescriptionFont": agreementDescriptionFont,
      "agreementDescriptionDarkColor": agreementDescriptionDarkColor,
      "linkLightColor": linkLightColor,
      "linkDarkColor": linkDarkColor,
      "allowButtonLightConfig": allowButtonLightConfig.toMap(),
      "allowButtonDarkConfig": allowButtonDarkConfig.toMap(),
      "rejectButtonLightConfig": rejectButtonLightConfig.toMap(),
      "rejectButtonDarkConfig": rejectButtonDarkConfig.toMap(),
    };
  }
}

class AuthButtonConfig {
  /**
 按钮的圆角半径
 */
double cornerRadius;

/**
 按钮默认背景颜色
 */
int normalBackgroundColor;

/**
 按钮按下背景颜色
 */
int pressedBackgroundColor;

/**
 按钮默认文字颜色
 */
int normalTextColor;

/**
 按钮按下文字颜色
 */
int pressedTextColor;

/**
 按钮默认边框颜色
 */
int normalBorderColor;

/**
 按钮按下边框颜色
 */
int pressedBorderColor;

Map<String, dynamic> toMap() {
    return {
      "cornerRadius": cornerRadius,
      "normalBackgroundColor": normalBackgroundColor,
      "pressedBackgroundColor": pressedBackgroundColor,
      "normalTextColor": normalTextColor,
      "pressedTextColor": pressedTextColor,
      "normalBorderColor": normalBorderColor,
      "pressedBorderColor": pressedBorderColor
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
  // 是否以单进程模式运行，仅限android，默认为false
  bool isSingleProcess;

  BaseAppletRequest({
    required this.apiServer,
    required this.appletId,
    this.startParams,
    this.animated = true,
    this.isSingleProcess = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "apiServer": apiServer,
      "appletId": appletId,
      "startParams": startParams,
      "animated": animated,
      "isSingleProcess": isSingleProcess,
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
// 是否以单进程模式运行，仅限android，默认为false
  bool isSingleProcess;

  RemoteAppletRequest({
    required this.apiServer,
    required this.appletId,
    this.startParams,
    this.sequence,
    this.offlineMiniprogramZipPath,
    this.offlineFrameworkZipPath,
    this.animated = true,
    this.isSingleProcess = false,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      "apiServer": apiServer,
      "appletId": appletId,
      "animated": animated,
      "isSingleProcess": isSingleProcess,
    };
    if (startParams != null) result["startParams"] = startParams;
    if (offlineMiniprogramZipPath != null)
      result["offlineMiniprogramZipPath"] = offlineMiniprogramZipPath;
    if (offlineFrameworkZipPath != null)
      result["offlineFrameworkZipPath"] = offlineFrameworkZipPath;
    if (sequence != null) result["sequence"] = sequence;

    return result;
  }
}

class QRCodeAppletRequest {
  // 二维码内容
  String qrCode;
  // 是否显示打开动画
  bool animated = true;
  // 是否以单进程模式运行，仅限android，默认为false
  bool isSingleProcess;

  QRCodeAppletRequest(this.qrCode, {this.isSingleProcess = false});

  Map<String, dynamic> toMap() {
    return {
      "apiServer": qrCode,
      "animated": animated,
      "isSingleProcess": isSingleProcess,
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

enum ConfigPriority {
  ConfigGlobalPriority , //全局配置优先
  ConfigSpecifiedPriority,  // 单个配置优先
  ConfigAppletFilePriority, // 小程序配置文件优先，小程序app.ext.json文件中配置
}

enum TranstionStyle {
  TranstionStyleUp,   // 页面从下往上弹出，类似present效果
  TranstionStylePush, // 页面从右往左弹出，类似push效果
}

class Mop {
  static final Mop _instance = new Mop._internal();
  late MethodChannel _channel;
  late EventChannel _mopEventChannel;
  late int eventId = 0;
  final List<Map<String, dynamic>> _mopEventQueye = <Map<String, dynamic>>[];

  final Map<String, MopAppletHandler> _appletHandlerApis = {};

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

      final apiHandler = _appletHandlerApis[name];
      if (apiHandler != null) {
        return await apiHandler(call.arguments);
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
  /// [config]   小程序相关配置
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

  Future<Map> newInitialize(
   FATConfig config,
   {
    UIConfig? uiConfig
   }
  }) async {
    List<Map<String, dynamic>>? storeConfigs =
        finStoreConfigs?.map((e) => e.toMap()).toList();

    final Map ret = await _channel.invokeMethod('newInitialize', {
      'config': config,
      'uiConfig': uiConfig,
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
    final bool isSingleProcess = false,
  }) async {
    Map<String, Object> params = {'appId': appId};
    Map param = {};
    if (path != null) param["path"] = path;
    if (query != null) param["query"] = query;
    if (param.length > 0) params["params"] = param;
    if (sequence != null) params["sequence"] = sequence;
    if (apiServer != null) params["apiServer"] = apiServer;
    if (scene != null) param["scene"] = scene;
    params["isSingleProcess"] = isSingleProcess;
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
  Future scanOpenApplet(String info, {bool isSingleProcess = false}) async {
    Map<String, Object> params = {
      'info': info,
      'isSingleProcess': isSingleProcess,
    };
    return await _channel.invokeMapMethod("scanOpenApplet", params);
  }

  ///
  /// 通过二维码打开小程序
  /// [qrcode] 二维码内容
  ///
  Future qrcodeOpenApplet(String qrcode, {bool isSingleProcess = false}) async {
    Map<String, Object> params = {
      'qrcode': qrcode,
      'isSingleProcess': isSingleProcess,
    };
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
    _appletHandlerApis["forwardApplet"] = (params) async {
      handler.forwardApplet(Map<String, dynamic>.from(params));
    };
    _appletHandlerApis["getUserInfo"] = (params) {
      return handler.getUserInfo();
    };
    _appletHandlerApis["getCustomMenus"] = (params) async {
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
    _appletHandlerApis["onCustomMenuClick"] = (params) async {
      return handler.onCustomMenuClick(
        params["appId"],
        params["path"],
        params["menuId"],
        params["appInfo"],
      );
    };
    _appletHandlerApis["appletDidOpen"] = (params) async {
      return handler.appletDidOpen(params["appId"]);
    };
    _appletHandlerApis["getPhoneNumber"] = (params) async {
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
    await _channel.invokeMethod("setActivityTransitionAnim", {"anim": ""});
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

  ///
  /// 将当前正在运行的最后一个打开的小程序移至任务栈前台
  ///
  void moveCurrentAppletToFront() async {
    return await _channel.invokeMethod("moveCurrentAppletToFront");
  }
}
