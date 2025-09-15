# FinClip Flutter SDK 项目文档

## 项目概述

这是 FinClip 小程序技术的 Flutter SDK，用于在 Flutter 应用中运行小程序。本 SDK 提供了完整的小程序运行环境，允许开发者在自己的 Flutter 应用中嵌入和运行小程序。

### 核心信息
- **项目名称**: mop (Mini-program On Platform)
- **当前版本**: 2.49.9
- **官方网站**: https://www.finclip.com
- **GitHub**: https://github.com/finogeeks/mop-flutter-sdk
- **最低 Flutter 版本**: 2.2.3
- **最低 Dart SDK**: 2.12.0

## 项目架构

### 1. 核心模块结构

```
finclip-flutter-sdk/
├── lib/                      # Flutter SDK 核心代码
│   ├── mop.dart             # 主入口类，包含所有 API 方法
│   └── api.dart             # API 接口定义（AppletHandler 等）
├── android/                 # Android 原生实现
│   └── src/main/java/       # Java/Kotlin 实现代码
├── ios/                     # iOS 原生实现
│   └── Classes/             # Objective-C/Swift 实现代码
└── example/                 # 示例项目
```

### 2. 依赖关系

#### Flutter 端依赖
- flutter_plugin_android_lifecycle: ^2.0.3

#### Android 端依赖
- finapplet: 2.49.9 (核心 SDK)
- plugins: 2.49.9 (扩展插件)

#### iOS 端依赖
- FinApplet: 2.49.9 (核心 SDK)
- FinAppletExt: 2.49.9 (扩展 SDK)

## 核心功能模块

### 1. SDK 初始化配置

#### Config 类
主要配置 SDK 的全局参数：

```dart
Config(List<FinStoreConfig> finStoreConfigs)
```

**关键配置项**：
- `finStoreConfigs`: 服务器配置列表（支持多服务器）
- `userId`: 用户标识
- `channel`: 渠道标识
- `phone`: 手机号
- `productIdentification`: 产品标识
- `disableRequestPermissions`: 是否禁用权限申请
- `appletAutoAuthorize`: 小程序自动授权
- `appletDebugMode`: 调试模式设置
- `language`: SDK 语言设置（中文/英文）
- `appletIntervalUpdateLimit`: 后台自动更新小程序个数（0-50）
- `pageCountLimit`: 页面栈最大限制
- `logLevel`: 日志级别
- `backgroundFetchPeriod`: 周期性更新时间间隔（3-12小时）

#### FinStoreConfig 类
配置服务器连接信息：

```dart
FinStoreConfig(sdkKey, sdkSecret, apiServer, {
  apmServer,         // APM 统计服务器地址
  cryptType,         // 加密类型：MD5/SM
  fingerprint,       // SDK 指纹（证联环境必填）
  encryptServerData, // 是否加密服务器数据
  enablePreloadFramework // 是否预加载基础库
})
```

#### UIConfig 类
配置 UI 相关参数：

**导航栏配置**：
- `navigationBarHeight`: 导航栏高度（默认44）
- `navigationBarTitleLightColor`: 标题颜色（深色主题）
- `navigationBarTitleDarkColor`: 标题颜色（明亮主题）
- `navigationBarBackBtnLightColor`: 返回按钮颜色（深色主题）
- `navigationBarBackBtnDarkColor`: 返回按钮颜色（明亮主题）

**菜单配置**：
- `isHideFeedbackAndComplaints`: 隐藏反馈与投诉
- `isHideBackHome`: 隐藏返回首页
- `isHideForwardMenu`: 隐藏转发
- `isHideShareAppletMenu`: 隐藏分享（默认true）
- `isHideAddToDesktopMenu`: 隐藏添加到桌面
- `isHideFavoriteMenu`: 隐藏收藏
- `isHideRefreshMenu`: 隐藏刷新
- `isHideSettingMenu`: 隐藏设置
- `isHideClearCacheMenu`: 隐藏清理缓存

**胶囊按钮配置（CapsuleConfig）**：
- 尺寸：宽度、高度、边距、圆角
- 颜色：背景色、边框色、分割线色
- 按钮：更多按钮、关闭按钮的图标和尺寸

**其他配置**：
- `autoAdaptDarkMode`: 自适应暗黑模式
- `useNativeLiveComponent`: 使用内置 live 组件
- `appendingCustomUserAgent`: 自定义 UserAgent
- `transtionStyle`: 打开动画方式
- `disableSlideCloseAppletGesture`: 禁用侧滑关闭手势

### 2. 核心 API 功能

#### 初始化 SDK
```dart
Future<Map> initSDK(Config config, {UIConfig? uiConfig})
```

#### 小程序管理

**打开小程序**：
```dart
// 新版推荐方式
Future<Map> startApplet(RemoteAppletRequest request)

// 旧版方式
Future<Map> openApplet(String appId, {
  String? path,
  String? query,
  int? sequence,
  String? apiServer,
  String? scene,
  String? shareDepth,
  bool isSingleProcess = false,
  bool isSingTask = false,
})
```

**RemoteAppletRequest 参数**：
- `apiServer`: 服务器地址（必填）
- `appletId`: 小程序 ID（必填）
- `startParams`: 启动参数（path、query）
- `sequence`: 小程序索引（审核时必填）
- `offlineMiniprogramZipPath`: 离线包路径
- `offlineFrameworkZipPath`: 离线基础库路径
- `animated`: 是否显示动画
- `transitionStyle`: 动画方式
- `reLaunchMode`: 触发 reLaunch 的条件模式

**二维码打开**：
```dart
Future<Map> qrcodeStartApplet(QRCodeAppletRequest qrcodeRequest)
```

**关闭小程序**：
```dart
Future<void> closeApplet(String appletId, bool animated)  // 关闭（内存中保留）
Future<void> finishRunningApplet(String appletId, bool animated)  // 彻底关闭
Future closeAllApplets()  // 关闭所有
```

**清理缓存**：
```dart
Future removeUsedApplet(String appId)  // 清除指定小程序缓存
Future removeAllUsedApplets()  // 清除所有缓存
Future clearApplets()  // 结束所有小程序
```

**获取信息**：
```dart
Future<Map<String, dynamic>> currentApplet()  // 获取当前小程序信息
Future<String> sdkVersion()  // 获取 SDK 版本
```

#### 3. 扩展能力

**注册小程序事件处理器**：
```dart
void registerAppletHandler(AppletHandler handler)
```

AppletHandler 接口方法：
- `forwardApplet`: 转发小程序
- `getUserInfo`: 获取用户信息
- `customCapsuleMoreButtonClick`: 自定义胶囊更多按钮点击（iOS）
- `getCustomMenus`: 获取自定义菜单
- `onCustomMenuClick`: 自定义菜单点击处理
- `appletDidOpen`: 小程序打开回调
- `getMobileNumber`: 获取手机号

**注册自定义 API**：
```dart
// 注册小程序自定义 API
void registerExtensionApi(String name, ExtensionApiHandler handler)

// 注册 WebView 自定义 API
void addWebExtentionApi(String name, ExtensionApiHandler handler)
```

**原生交互**：
```dart
// 调用小程序中的 JS 方法
Future<void> callJS(String appId, String eventName, String nativeViewId, Map<String, dynamic> eventData)

// 发送自定义事件给小程序
Future<void> sendCustomEvent(String appId, Map<String, dynamic> eventData)
```

### 4. 枚举类型

**FCReLaunchMode（热启动模式）**：
- `PARAMS_EXIST`: 有启动参数就执行 reLaunch
- `ONLY_PARAMS_DIFF`: 参数不同才执行 reLaunch
- `ALWAYS`: 总是执行 reLaunch
- `NEVER`: 永不执行 reLaunch

**TranstionStyle（动画方式）**：
- `TranstionStyleUp`: 从下往上弹出（present）
- `TranstionStylePush`: 从右往左弹出（push）

**BOOLState（调试模式）**：
- `BOOLStateUndefined`: 未设置
- `BOOLStateTrue`: 强制开启
- `BOOLStateFalse`: 非正式版可切换
- `BOOLStateForbidden`: 强制关闭

**LanguageType（语言类型）**：
- `Chinese`: 中文
- `English`: 英文

**LogLevel（日志级别）**：
- `LEVEL_ERROR`
- `LEVEL_WARNING`
- `LEVEL_INFO`
- `LEVEL_DEBUG`
- `LEVEL_VERBOSE`
- `LEVEL_NONE`

**ConfigPriority（配置优先级）**：
- `ConfigGlobalPriority`: 全局配置优先
- `ConfigSpecifiedPriority`: 单个配置优先
- `ConfigAppletFilePriority`: 小程序配置文件优先

## 平台特定功能

### Android 特有功能
- `maxRunningApplet`: 最大同时运行小程序个数
- `webViewMixedContentMode`: WebView 混合内容模式
- `bindAppletWithMainProcess`: 小程序与主进程绑定
- `minAndroidSdkVersion`: 最低支持 Android SDK 版本（默认21）
- `enableScreenShot`: 是否允许截屏录屏
- `enablePreNewProcess`: 是否提前创建进程
- `useLocalTbsCore`: 使用本地 TBS 内核
- `enableJ2V8`: 是否开启 J2V8
- `loadingLayoutCls`: Loading 页回调类

### iOS 特有功能
- `baseLoadingViewClass`: 自定义启动加载页类名
- `baseLoadFailedViewClass`: 自定义启动失败页类名
- `enableH5AjaxHook`: 开启 H5 页面 hook 功能
- `h5AjaxHookRequestKey`: hook 请求的参数名
- `customLanguagePath`: 自定义语言路径
- `startCrashProtection`: 开启崩溃防护

## 示例代码使用

### 基本初始化和打开小程序

```dart
// 1. 配置服务器
FinStoreConfig storeConfig = FinStoreConfig(
  "SDK_KEY",
  "SDK_SECRET",
  "https://api.finclip.com",
  cryptType: "SM",
);

// 2. 创建配置
Config config = Config([storeConfig]);
config.userId = "user123";
config.appletDebugMode = BOOLState.BOOLStateTrue;

// 3. UI 配置
UIConfig uiConfig = UIConfig();
uiConfig.isHideBackHome = false;

// 4. 初始化 SDK
await Mop.instance.initSDK(config, uiConfig: uiConfig);

// 5. 打开小程序
RemoteAppletRequest request = RemoteAppletRequest(
  apiServer: 'https://api.finclip.com',
  appletId: 'YOUR_APPLET_ID',
  startParams: {'path': '/pages/index/index', 'query': 'key=value'},
);
await Mop.instance.startApplet(request);
```

### 注册自定义处理器

```dart
class MyAppletHandler extends AppletHandler {
  @override
  Future<Map<String, dynamic>> getUserInfo() {
    return Future.value({
      "userInfo": {
        "nickName": "用户昵称",
        "avatarUrl": "头像URL",
      }
    });
  }

  @override
  Future<List<CustomMenu>> getCustomMenus(String appId) {
    return Future.value([
      CustomMenu('menu1', 'icon_url', '菜单1', 'common'),
    ]);
  }

  // 实现其他方法...
}

// 注册处理器
Mop.instance.registerAppletHandler(MyAppletHandler());
```

### 注册自定义 API

```dart
// 注册扩展 API
Mop.instance.registerExtensionApi('myCustomApi', (params) async {
  // 处理自定义 API 调用
  return {"result": "success", "data": params};
});
```

## 项目文件说明

### 核心文件
- `/lib/mop.dart`: SDK 主类，包含所有 API 实现
- `/lib/api.dart`: API 接口定义
- `/example/lib/main.dart`: 完整示例代码
- `/example/lib/test_page.dart`: 测试页面实现

### 配置文件
- `/pubspec.yaml`: Flutter 包配置
- `/android/build.gradle`: Android 构建配置
- `/ios/mop.podspec`: iOS Pod 配置

### 脚本文件
- `/publish.sh`: 发布脚本
- `/update_version.sh`: 版本更新脚本
- `/bundle.sh`: 打包脚本
- `/tag.sh`: Git 标签脚本

## 注意事项

1. **初始化时机**：必须在使用任何 API 之前完成 SDK 初始化
2. **权限配置**：根据需要配置 `disableRequestPermissions` 和 `appletAutoAuthorize`
3. **多服务器支持**：可配置多个 FinStoreConfig 实现多服务器切换
4. **调试模式**：开发阶段建议开启 `appletDebugMode`
5. **内存管理**：注意及时清理不用的小程序缓存
6. **平台差异**：部分配置项仅在特定平台生效，使用时需注意
7. **版本兼容**：确保 Flutter SDK 版本与原生 SDK 版本匹配（当前均为 2.49.9）

## 常见问题

1. **小程序打不开**：检查 SDK 初始化是否成功，服务器配置是否正确
2. **权限问题**：检查 `disableRequestPermissions` 配置
3. **UI 定制**：通过 UIConfig 和 CapsuleConfig 进行界面定制
4. **自定义 API 不生效**：iOS 需要在小程序根目录创建 FinChatConf.js 配置文件
5. **性能优化**：合理设置 `appletIntervalUpdateLimit` 和 `backgroundFetchPeriod`