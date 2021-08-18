# 凡泰极客小程序 Flutter 插件

本插件提供在 Flutter 运行环境中运行小程序能力。

## 集成

在项目pubspec.yaml文件中添加依赖

```
mop: latest.version
```

## 示例

```
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
    if (Platform.isIOS) {
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

## 接口文档

1. 初始化小程序

在使用sdk提供的api之前必须要初始化sdk，初始化sdk的接口为

```

  ///
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

使用示例:

```
final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauARlLry7JL/2fRpscC9kpGZQA', '1c11d7252c53e0b6',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
```

2. 打开小程序

```
  ///
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

3. 获取当前正在使用的小程序信息

当前小程序信息包括的字段有appId,name,icon,description,version,thumbnail

```
  ///
  ///  get current using applet
  ///  获取当前正在使用的小程序信息
  ///  {appId,name,icon,description,version,thumbnail}
  ///
  ///
  Future<Map<String, dynamic>> currentApplet()
```

4. 关闭当前打开的所有小程序

```
  ///
  /// close all running applets
  /// 关闭当前打开的所有小程序
  ///
  Future closeAllApplets()
```

5. 清除缓存的小程序

清除缓存的小程序，当再次打开时，会重新下载小程序

```
  ///
  /// clear applets cache
  /// 清除缓存的小程序
  ///
  Future clearApplets() 
```

6. 注册小程序事件处理

当小程序内触发指定事件时，会通知到使用者，比如小程序被转发，小程序需要获取用户信息，注册处理器来做出对应的响应

```
  ///
  /// register handler to provide custom info or behaviour
  /// 注册小程序事件处理
  ///
  void registerAppletHandler(AppletHandler handler) 
```

处理器的结构

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

7. 注册拓展api

如果，我们的小程序SDK API不满足您的需求，您可以注册自定义的小程序API，然后就可以在小程序内调用自已定义的API了。

···
  ///
  /// register extension api
  /// 注册拓展api
  ///
  void registerExtensionApi(String name, ExtensionApiHandler handler)
···

ios需要在小程序根目录创建FinChatConf.js文件，配置实例如下

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

## Debug
```text
## for ios
ENABLE_BITCODE false
```
