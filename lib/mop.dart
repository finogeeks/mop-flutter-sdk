import 'dart:async';

import 'package:flutter/services.dart';

typedef MopEventCallback = void Function(dynamic event);
typedef MopEventErrorCallback = void Function(dynamic event);

class Mop {
  static final Mop _instance = new Mop._internal();
  MethodChannel _channel;
  EventChannel _mopEventChannel;
  int eventId = 0;
  List<Map<String, dynamic>> _mopEventQueye = <Map<String, dynamic>>[];
  factory Mop() {
    return _instance;
  }
  Mop._internal() {
    print('mop: _internal');
    // init
    _channel = new MethodChannel('mop');
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

  ///
  ///
  /// initialize mop miniprogram engine.
  /// 初始化小程序
  /// [appkey] is required. it can be getted from mp.finogeeks.com
  /// [secret] is required. it can be getted from mp.finogeeks.com
  /// [apiServer] is optional. the mop server address. default is https://mp.finogeek.com
  /// [apiPrefix] is optional. the mop server prefix. default is /api/v1/mop
  ///
  ///
  Future<Map> initialize(String appkey, String secret,
      {String apiServer, String apiPrefix}) async {
    final Map ret = await _channel.invokeMethod('initialize', {
      'appkey': appkey,
      'secret': secret,
      'apiServer': apiServer,
      'apiPrefix': apiPrefix
    });
    return ret;
  }

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
      {final String path, final String query}) async {
    Map<String, Object> params;
    if (path != '') {
      params = {
        'appId': appId,
        'params': {'path': path, 'query': query}
      };
    } else {
      params = {'appId': appId};
    }
    final Map ret = await _channel.invokeMethod('openApplet', params);
    return ret;
  }
}
