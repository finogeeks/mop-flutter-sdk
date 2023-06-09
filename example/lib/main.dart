// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mop/api.dart';
import 'dart:async';
import 'dart:io';
import 'package:mop/mop.dart';

void main() => runApp(MyApp());

const toAppMessageChannel = MethodChannel("com.message.flutter_to_app");

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

    //多服务器配置
    FinStoreConfig storeConfigA = FinStoreConfig(
      "22LyZEib0gLTQdU3MUauAfJ/xujwNfM6OvvEqQyH4igA",
      "703b9026be3d6bc5",
      "https://api.finclip.com",
      cryptType: "SM",
    );

    FinStoreConfig storeConfigB = FinStoreConfig(
      "22LyZEib0gLTQdU3MUauAfJ/xujwNfM6OvvEqQyH4igA",
      "703b9026be3d6bc5",
      "https://finchat-mop-b.finogeeks.club"
    );
    List<FinStoreConfig> storeConfigs = [storeConfigA];
    Config config = Config(storeConfigs);
    config.language = LanguageType.English;
    config.baseLoadingViewClass = "LoadingView";
    
    UIConfig uiconfig = UIConfig();
    uiconfig.isAlwaysShowBackInDefaultNavigationBar = false;
    uiconfig.isClearNavigationBarNavButtonBackground = false;
    uiconfig.isHideFeedbackAndComplaints = true;
    uiconfig.isHideBackHome = true;
    uiconfig.isHideForwardMenu = true;
    CapsuleConfig capsuleConfig = CapsuleConfig();
    // capsuleConfig.capsuleBgLightColor = 0x33ff00ee;
    capsuleConfig.capsuleCornerRadius = 16;
    // capsuleConfig.capsuleRightMargin = 25;
    uiconfig.capsuleConfig = capsuleConfig;
    uiconfig.appletText = "applet";
    uiconfig.loadingLayoutCls = "com.finogeeks.mop_example.CustomLoadingPage";

    // if (Platform.isIOS) {
    //   final res = await Mop.instance.initialize(
    //       '22LyZEib0gLTQdU3MUauATBwgfnTCJjdr7FCnywmAEM=', 'bdfd76cae24d4313',
    //       apiServer: 'https://api.finclip.com',
    //       apiPrefix: '/api/v1/mop',
    //       uiConfig: uiconfig,
    //       finStoreConfigs: storeConfigs);
    //   print(res);
    // } else if (Platform.isAndroid) {
    //   final res = await Mop.instance.initialize(
    //       '22LyZEib0gLTQdU3MUauATBwgfnTCJjdr7FCnywmAEM=', 'bdfd76cae24d4313',
    //       apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
    //   print(res);
    // }

    final res = await Mop.instance.initSDK(config, uiConfig: uiconfig);
    print(res);
    Mop.instance.registerAppletHandler(MyAppletHandler());

    if (!mounted) return;
  }

  Widget _buildAppletItem(
      String appletId, String itemName, VoidCallback tapAction) {
    return GestureDetector(
      onTap: tapAction,
      child: Container(
        padding: EdgeInsets.only(left: 7, right: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
            stops: const [0.0, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(
            itemName,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildAppletWidget(String appletId, String appletName) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 30, right: 20),
      child: Column(
        children: [
          Text(
            appletName,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 30,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                _buildAppletItem(appletId, "打开小程序", () {
                  TranstionStyle style = TranstionStyle.TranstionStyleUp;
                  if (appletId == "5f72e3559a6a7900019b5baa") {
                    style = TranstionStyle.TranstionStylePush;
                  }
                  RemoteAppletRequest request = RemoteAppletRequest(apiServer: 'https://api.finclip.com', appletId: appletId, transitionStyle: style);
                  Mop.instance.startApplet(request);

                  // Mop.instance.qrcodeOpenApplet('https://api.finclip.com/api/v1/mop/runtime/applet/-f-MGYzN2Q1YTYzMmI2MWIyZg--');

                }),
                _buildAppletItem(appletId, "finishRunningApplet", () {
                  Mop.instance.finishRunningApplet(appletId, true);
                }),
                _buildAppletItem(appletId, "removeUsedApplet", () {
                  Mop.instance.removeUsedApplet(appletId);
                }),
                // _buildAppletItem(appletId, "removeUsedApplet", () {
                //   Mop.instance.removeUsedApplet(appletId);
                // }),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 5e637a18cbfae4000170fa7a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('凡泰极客小程序 Flutter 插件'),
        ),
        body: Column(
          children: <Widget>[
            _buildAppletWidget("5facb3a52dcbff00017469bd", "画图小程序"),
            _buildAppletWidget("5f72e3559a6a7900019b5baa", "官方小程序"),
            _buildAppletWidget("5fa215459a6a7900019b5cc3", "我的对账单"),
          ],
        ),
      ),
    );
  }
}

class MyAppletHandler extends AppletHandler {
  @override
  Future<void> appletDidOpen(String appId) async {
    print("appletDidOpen appId:$appId");
  }

  @override
  bool customCapsuleMoreButtonClick(String appId) {
    print("customCapsuleMoreButtonClick---");
    // toAppMessageChannel.invokeMethod("showCustomMoreView", {"appId": appId});
    return false;
  }

  @override
  void forwardApplet(Map<String, dynamic> appletInfo) {
    print("forwardApplet ---");
  }

  @override
  Future<List<CustomMenu>> getCustomMenus(String appId) {
    List<CustomMenu> customMenus = [
      CustomMenu('WXShareAPPFriends', 'https://img1.baidu.com/it/u=2878938773,1765835171&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', '微信好朋友', 'common'),
      CustomMenu('WXShareAPPMoments', 'minipro_list_collect', '微信朋友圈', 'common'),
      CustomMenu('MyFriends', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpvugSNLs9R7iopz_noeotAelvgzYj-74iCg&usqp=CAU', '我的好友', 'common'),

      // CustomMenu('WXShareAPPFriends', 'https://img1.baidu.com/it/u=2878938773,1765835171&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', '微信好朋友', 'common'),
      // CustomMenu('WXShareAPPMoments', 'https://img2.baidu.com/it/u=3113705544,436318069&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', '微信朋友圈', 'common'),

      // CustomMenu('WXShareAPPFriends', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpvugSNLs9R7iopz_noeotAelvgzYj-74iCg&usqp=CAU', '微信好朋友', 'common'),
      // CustomMenu('WXShareAPPMoments', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7cO4KB4e5-Ugdcq4pIyWunliH7LZRZzguKQ&usqp=CAU', '微信朋友圈', 'common'),
    ];
    return Future.value(customMenus);
  }

  @override
  Future<void> getMobileNumber(Function(dynamic params) callback) {
    // TODO: implement getMobileNumber
    Map<String, dynamic> result = {"phone": '18607180143',"other":'abc123'};
    print('getMobileNumber:' + result.toString());
    callback(result);
    return Future.value(null);
  }

  @override
  Future<Map<String, dynamic>> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<void> onCustomMenuClick(String appId, String path, String menuId, String appInfo) {
    // TODO: implement onCustomMenuClick
    throw UnimplementedError();
  }

}
