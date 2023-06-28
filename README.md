<p align="center">
    <a href="https://www.finclip.com?from=github">
    <img width="auto" src="https://www.finclip.com/mop/document/images/logo.png">
    </a>
</p>

<p align="center">
    <strong>FinClip Flutter SDK</strong></br>
<p>
<p align="center">
        本项目提供在 Flutter 环境中运行小程序的能力
<p>

<p align="center">
	👉 <a href="https://www.finclip.com?from=github">https://www.finclip.com/</a> 👈
</p>

<div align="center">

<a href="#"><img src="https://img.shields.io/badge/%E4%B8%93%E5%B1%9E%E5%BC%80%E5%8F%91%E8%80%85-20000%2B-brightgreen"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%B7%B2%E4%B8%8A%E6%9E%B6%E5%B0%8F%E7%A8%8B%E5%BA%8F-6000%2B-blue"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%B7%B2%E9%9B%86%E6%88%90%E5%B0%8F%E7%A8%8B%E5%BA%8F%E5%BA%94%E7%94%A8-75%2B-yellow"></a>
<a href="#"><img src="https://img.shields.io/badge/%E5%AE%9E%E9%99%85%E8%A6%86%E7%9B%96%E7%94%A8%E6%88%B7-2500%20%E4%B8%87%2B-orange"></a>

<a href="https://www.zhihu.com/org/finchat"><img src="https://img.shields.io/badge/FinClip--lightgrey?logo=zhihu&style=social"></a>
<a href="https://www.finclip.com/blog/"><img src="https://img.shields.io/badge/FinClip%20Blog--lightgrey?logo=ghost&style=social"></a>



</div>

<p align="center">

<div align="center">

[官方网站](https://www.finclip.com/) | [示例小程序](https://www.finclip.com/#/market) | [开发文档](https://www.finclip.com/mop/document/) | [部署指南](https://www.finclip.com/mop/document/introduce/quickStart/cloud-server-deployment-guide.html) | [SDK 集成指南](https://www.finclip.com/mop/document/introduce/quickStart/intergration-guide.html) | [API 列表](https://www.finclip.com/mop/document/develop/api/overview.html) | [组件列表](https://www.finclip.com/mop/document/develop/component/overview.html) | [隐私承诺](https://www.finclip.com/mop/document/operate/safety.html)

</div>

-----
## 🤔 FinClip 是什么?

有没有**想过**，开发好的微信小程序能放在自己的 APP 里直接运行，只需要开发一次小程序，就能在不同的应用中打开它，是不是很不可思议？

有没有**试过**，在自己的 APP 中引入一个 SDK ，应用中不仅可以打开小程序，还能自定义小程序接口，修改小程序样式，是不是觉得更不可思议？

这就是 FinClip ，就是有这么多不可思议！

## ⚠️ Flutter 使用注意

由于 FinClip 小程序技术主要通过 SDK 向 APP 提供运行小程序的能力，您看到的本仓库中长期未更新的文件并非“年久失修”，我们始终保持在 Flutter 环境中 SDK 资源的定期更新。如果您在集成使用过程中遇到任何问题，欢迎与我们联系。

## ⚙️ Flutter 集成

在项目 `pubspec.yaml` 文件中添加依赖

```yaml
mop: latest.version
```

## 🖥 示例

```flutter
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mop/mop.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    if (Platform.isiOS) {
      //com.finogeeks.mopExample
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARlLry7JL/2fRpscC9kpGZQA', '1c11d7252c53e0b6',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
      print(res);
    } else if (Platform.isAndroid) {
      //com.finogeeks.mopexample
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARjmmp6QmYgjGb3uHueys1oA', '98c49f97a031b555',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
      print(res);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('凡泰极客小程序 Flutter 插件'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Mop.instance.openApplet('5e3c147a188211000141e9b1');
                    },
                    child: Text(
                      '打开示例小程序',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Mop.instance.openApplet('5e4d123647edd60001055df1',sequence: 1);
                    },
                    child: Text(
                      '打开官方小程序',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## 📋  接口文档

### 1. 初始化小程序

   在使用 SDK 提供的 API 之前必须要初始化 SDK ，初始化 SDK 的接口如下

```
  ///
  /// initialize mop miniprogram engine.
  /// 初始化小程序
  /// [appkey] is required. it can be getted from api.finclip.com
  /// [secret] is required. it can be getted from api.finclip.com
  /// [apiServer] is optional. the mop server address. default is https://mp.finogeek.com
  /// [apiPrefix] is optional. the mop server prefix. default is /api/v1/mop
  ///
  ///
  Future<Map> initialize(String appkey, String secret,
      {String apiServer, String apiPrefix})
```

使用示例：
```
final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARlLry7JL/2fRpscC9kpGZQA', '1c11d7252c53e0b6',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
```

### 2. 打开小程序

```
  ///
  /// open the miniprogram [appId] from the  mop server.
  /// 打开小程序
  /// [appId] is required.
  /// [path] is miniprogram open path. example /pages/index/index
  /// [query] is miniprogram query parameters. example key1=value1&key2=value2
  ///
  ///
  Future<Map> openApplet(final String appId,
      {final String path, final String query, final int sequence})
```

### 3. 获取当前正在使用的小程序信息

当前小程序信息包括的字段有 `appId`, `name`, `icon`, `description`, `version`, `thumbnail`

```
  ///
  ///  get current using applet
  ///  获取当前正在使用的小程序信息
  ///  {appId,name,icon,description,version,thumbnail}
  ///
  ///
  Future<Map<String, dynamic>> currentApplet()
```

### 4. 关闭当前打开的所有小程序

```
  ///
  /// close all running applets
  /// 关闭当前打开的所有小程序
  ///
  Future closeAllApplets()
```

### 5. 清除缓存的小程序

清除缓存的小程序，当再次打开时，会重新下载小程序
```
  ///
  /// clear applets cache
  /// 清除缓存的小程序
  ///
  Future clearApplets() 
```

### 6. 注册小程序事件处理

当小程序内触发指定事件时，会通知到使用者，比如小程序被转发，小程序需要获取用户信息，注册处理器来做出对应的响应

```
  ///
  /// register handler to provide custom info or behaviour
  /// 注册小程序事件处理
  ///
  void registerAppletHandler(AppletHandler handler) 
```

处理类的结构
```
abstract class AppletHandler {
  ///
  /// 转发小程序
  ///
  ///
  ///
  void forwardApplet(Map<String, dynamic> appletInfo);

  ///
  ///获取用户信息
  ///  "userId"
  ///  "nickName"
  ///  "avatarUrl"
  ///  "jwt"
  ///  "accessToken"
  ///
  Future<Map<String, dynamic>> getUserInfo();

  /// 获取自定义菜单
  Future<List<CustomMenu>> getCustomMenus(String appId);

  ///自定义菜单点击处理
  Future onCustomMenuClick(String appId, int menuId);
}
```

### 7. 注册拓展 API

如果，我们的小程序 SDK API 不满足您的需求，您可以注册自定义的小程序API，然后就可以在小程序内调用自已定义的 API 了。

```
  ///
  /// register extension api
  /// 注册拓展api
  ///
  void registerExtensionApi(String name, ExtensionApiHandler handler)
```

iOS 需要在小程序根目录创建 `FinChatConf.js` 文件，配置实例如下

```
module.exports = {
  extApi:[
    { //普通交互API
      name: 'onCustomEvent', //扩展api名 该api必须Native方实现了
      params: { //扩展api 的参数格式，可以只列必须的属性
        url: ''
      }
    }
  ]
}
```

## Flutter-SDK 工程源码说明
```
.
├── CHANGELOG.md
├── LICENSE
├── README.md
├── android
│   ├── build.gradle
│   ├── build.gradle.tpl
│   ├── gradle
│   │   └── wrapper
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── proguard-android.txt
│   ├── proguard-rules.pro
│   ├── settings.gradle
│   └── src     // Flutter-SDK Android源文件目录
│       └── main
│           ├── AndroidManifest.xml
│           └── java
│               └── com
│                   └── finogeeks
│                       └── mop
│                           ├── MopEventStream.java         // 
│                           ├── MopPlugin.java              // flutter 消息的处理类
│                           ├── MopPluginDelegate.java      //
│                           ├── api
│                           │   ├── AbsApi.java             // flutter-API的抽象类
│                           │   ├── ApisManager.java        // flutter-API的管理类
│                           │   ├── BaseApi.java            // flutter-API的基类
│                           │   ├── EmptyApi.java           // flutter-API的空实现
│                           │   └── mop
│                           │       ├── AppletHandlerModule.java  // 安卓代理的处理类，会转发消息至AppletHandler
│                           │       ├── AppletManageModule.java  // 小程序相关API的实现Module(包含获取小程序信息、关闭小程序、删除小程序等)
│                           │       ├── AppletModule.java       // 打开小程序的API实现Module（包含打开小程序的几种api）
│                           │       ├── BaseModule.java         // 旧版本初始化SDK的API实现Module
│                           │       ├── ExtensionApiModule.java  // 扩展API的实现Module（注册小程序自定义API、H5自定义API）
│                           │       ├── InitSDKModule.java  // 新版初始化SDK的Module
│                           │       ├── SmSignModule.java   // (废弃)
│                           │       ├── VersionModule.java  // 获取SDK版本信息的Module
│                           │       ├── WXQrCodeModule.java  //通过微信小程序二维码获取关联的FinClip 小程序信息的Module
│                           │       └── util   // 工具类
│                           │           └── InitUtils.java  //初始化参数处理工具类
│                           ├── constants
│                           │   └── Constants.java      // 常量
│                           ├── interfaces    // 一些接口类
│                           │   ├── Event.java
│                           │   ├── FlutterInterface.java
│                           │   ├── IApi.java
│                           │   ├── ICallback.java
│                           │   └── ILifecycle.java
│                           ├── service
│                           │   └── MopPluginService.java    // Flutter 插件服务
│                           └── utils
│                               ├── AppletUtils.java        // 小程序操作工具类
│                               └── GsonUtil.java           //json 处理工具类
├── example     // 示例工程目录
│   ├── README.md
│   ├── analysis_options.yaml
│   ├── android // 示例工程--安卓工程
│   │   ├── app
│   │   │   ├── build.gradle
│   │   │   └── src
│   │   │       ├── debug
│   │   │       │   └── AndroidManifest.xml
│   │   │       ├── main
│   │   │       │   ├── AndroidManifest.xml
│   │   │       │   ├── java
│   │   │       │   │   └── com
│   │   │       │   │       └── finogeeks
│   │   │       │   │           └── mop_example
│   │   │       │   │               ├── CustomLoadingPage.java  //安卓自定义loading实现类
│   │   │       │   │               ├── MainActivity.java       //安卓主页
│   │   │       │   │               └── MainApplication.java   
│   │   │       │   └── res   图片、布局等资源文件夹
│   │   │       └── profile
│   │   │           └── AndroidManifest.xml
│   │   ├── build.gradle
│   │   ├── gradle
│   │   │   └── wrapper
│   │   │       └── gradle-wrapper.properties
│   │   ├── gradle.properties
│   │   └── settings.gradle
│   ├── ios     // 示例工程--iOS工程
│   │   ├── Podfile
│   │   ├── Runner
│   │   │   ├── AppDelegate.swift   // 示例工程原生端初始化，以及插件注册
│   │   │   ├── Assets.xcassets
│   │   │   ├── FlutterMethodChannelHandler.h   // Flutter调用原生channel
│   │   │   ├── FlutterMethodChannelHandler.m
│   │   │   ├── LoadingView.h   // 小程序启动页自定义UI
│   │   │   ├── LoadingView.m
│   │   │   └── Runner-Bridging-Header.h
│   │   ├── Runner.xcodeproj
│   ├── lib
│   │   └── main.dart   // 示例工程入口
│   ├── pubspec.yaml
├── ios                 // iOS源文件目录
│   ├── Assets
│   ├── Classes
│   │   ├── Api     // flutter-sdk API的iOS实现类
│   │   │   ├── MOPAppletDelegate.h     // iOS SDK代理的实现类，会转发消息至AppletHandler
│   │   │   ├── MOPAppletDelegate.m     // iOS SDK代理的实现类，会转发消息至AppletHandler
│   │   │   ├── MOP_addWebExtentionApi.h    // 注册小程序H5 自定义api的实现类
│   │   │   ├── MOP_addWebExtentionApi.m    
│   │   │   ├── MOP_callJS.h            // 原生给小程序组件发消息的实现类
│   │   │   ├── MOP_callJS.m
│   │   │   ├── MOP_changeUserId.h      // 修复userId的实现类
│   │   │   ├── MOP_changeUserId.m
│   │   │   ├── MOP_clearApplets.h      // 清除本地所有小程序的实现类
│   │   │   ├── MOP_clearApplets.m
│   │   │   ├── MOP_closeAllApplets.h   // 关闭所有小程序的实现类
│   │   │   ├── MOP_closeAllApplets.m
│   │   │   ├── MOP_closeApplet.h       // 关闭指定小程序的实现类
│   │   │   ├── MOP_closeApplet.m
│   │   │   ├── MOP_currentApplet.h     // 获取当前小程序的信息的实现类
│   │   │   ├── MOP_currentApplet.m
│   │   │   ├── MOP_finishRunningApplet.h   // 彻底关闭小程序的实现类
│   │   │   ├── MOP_finishRunningApplet.m
│   │   │   ├── MOP_initSDK.h           // 新的初始化SDK实现类(推荐)
│   │   │   ├── MOP_initSDK.m       
│   │   │   ├── MOP_initialize.h        // 旧的初始化SDK实现类(不推荐)
│   │   │   ├── MOP_initialize.m
│   │   │   ├── MOP_openApplet.h        // 旧的打开小程序实现类（不推荐）
│   │   │   ├── MOP_openApplet.m
│   │   │   ├── MOP_parseAppletInfoFromWXQrCode.h   // 解析微信小程序二维码，得到凡泰小程序信息
│   │   │   ├── MOP_parseAppletInfoFromWXQrCode.m
│   │   │   ├── MOP_qrcodeOpenApplet.h      // 通过二维码链接打开小程序实现类
│   │   │   ├── MOP_qrcodeOpenApplet.m
│   │   │   ├── MOP_registerAppletHandler.h // 注册代理实现类
│   │   │   ├── MOP_registerAppletHandler.m
│   │   │   ├── MOP_registerExtensionApi.h  // 注册小程序自定义api的实现类
│   │   │   ├── MOP_registerExtensionApi.m
│   │   │   ├── MOP_removeAllUsedApplets.h  // 删除本地所有小程序的实现类（小程序包、运行过程中的数据等）
│   │   │   ├── MOP_removeAllUsedApplets.m
│   │   │   ├── MOP_removeApplet.h          // 删除指定小程序（小程序包、运行过程中的数据等）
│   │   │   ├── MOP_removeApplet.m
│   │   │   ├── MOP_removeUsedApplet.h      // 删除指定小程序（小程序包、运行过程中的数据等）
│   │   │   ├── MOP_removeUsedApplet.m
│   │   │   ├── MOP_scanOpenApplet.h        // 旧版二维码打开小程序。（需要解密二维码内容，废弃）
│   │   │   ├── MOP_scanOpenApplet.m
│   │   │   ├── MOP_sdkVersion.h            // 获取SDK版本信息
│   │   │   ├── MOP_sdkVersion.m
│   │   │   ├── MOP_sendCustomEvent.h       // 给SDK发动全局自定义事件
│   │   │   ├── MOP_sendCustomEvent.m
│   │   │   ├── MOP_showBotomSheetModel.h   // 显示底部分享View
│   │   │   ├── MOP_showBotomSheetModel.m
│   │   │   ├── MOP_smsign.h                // (废弃)
│   │   │   ├── MOP_smsign.m
│   │   │   ├── MOP_startApplet.h           // 新的启动小程序实现类(推荐)
│   │   │   ├── MOP_startApplet.m
│   │   │   ├── MOP_webViewBounces.h        // 设置顶层 webView的弹性效果
│   │   │   └── MOP_webViewBounces.m    
│   │   ├── Model
│   │   │   ├── MopCustomMenuModel.h        // 自定义菜单Model
│   │   │   └── MopCustomMenuModel.m
│   │   ├── MopPlugin.h                     // flutter 与 iOS原生通信桥接类
│   │   ├── MopPlugin.m
│   │   └── Utils           // 存放一些工具类
│   │       ├── MOPApiConverter.h   // Api动态转换类（使用runtime将request动态转换为api实现类）
│   │       ├── MOPApiConverter.m
│   │       ├── MOPApiRequest.h   // flutter-sdk传递给原生的事件和参数会封装成一个Request
│   │       ├── MOPApiRequest.m
│   │       ├── MOPBaseApi.h      // flutter API实现类的基类
│   │       ├── MOPBaseApi.m
│   │       ├── MOPTools.h        // 工具类（包含颜色、截图、获取顶层控制器等）
│   │       ├── MOPTools.m
│   │       ├── MopShareView.h    // 分享界面UI
│   │       ├── MopShareView.m
│   │       ├── UIView+MOPFATToast.h  // Toast提示分类
│   │       └── UIView+MOPFATToast.m
│   ├── mop.podspec
│   └── mop.podspec.tpl   //mop.podspec 模板文件
├── lib
│   ├── api.dart        // flutter-sdk代理的（抽象类）
│   └── mop.dart        // mop 核心类（包含初始化配置型、flutter-sdk的所有api）
├── publish.sh          // 发布脚本
├── pubspec.tpl.yaml    // pubspec.yaml模板文件
├── pubspec.yaml        // 配置文件
├── tag.sh              // 打tag的脚本
└── trigger.sh          // 脚本
```

## 🔗 常用链接
以下内容是您在 FinClip 进行开发与体验时，常见的问题与指引信息

- [FinClip 官网](https://www.finclip.com/#/home)
- [示例小程序](https://www.finclip.com/#/market)
- [文档中心](https://www.finclip.com/mop/document/)
- [SDK 部署指南](https://www.finclip.com/mop/document/introduce/quickStart/intergration-guide.html)
- [小程序代码结构](https://www.finclip.com/mop/document/develop/guide/structure.html)
- [iOS 集成指引](https://www.finclip.com/mop/document/runtime-sdk/ios/ios-integrate.html)
- [Android 集成指引](https://www.finclip.com/mop/document/runtime-sdk/android/android-integrate.html)
- [Flutter 集成指引](https://www.finclip.com/mop/document/runtime-sdk/flutter/flutter-integrate.html)

## ☎️ 联系我们
微信扫描下面二维码，关注官方公众号 **「凡泰极客」**，获取更多精彩内容。<br>
<img width="150px" src="https://www.finclip.com/mop/document/images/ic_qr.svg">

微信扫描下面二维码，加入官方微信交流群，获取更多精彩内容。<br>
<img width="150px" src="https://www-cdn.finclip.com/images/qrcode/qrcode_shequn_text.png">
