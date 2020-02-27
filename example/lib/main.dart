import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // String platformVersion;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await Mop.instance.platformVersion;
    //   print(platformVersion);
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }
    final res = await Mop.instance.initialize(
        '22LyZEib0gLTQdU3MUauARjmmp6QmYgjGb3uHueys1oA', '98c49f97a031b555',
        apiServer: 'https://mp.finogeeks.com', apiPrefix: '/api/v1/');
    print(res);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: FlatButton(
          onPressed: () {
            // appId: '5e3c147a188211000141e9b1',
            // path: "/pages/index/index",
            // query: "key1=value1&key2=value2",
            // scene: "1001"
            Mop.instance.openApplet('5e3c147a188211000141e9b1',
                path: '/pages/index/index', query: 'key1=value1&key2=value2');
          },
          child: Text('打开小程序'),
        )),
      ),
    );
  }
}
