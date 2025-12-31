import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

/// 平台视图事件代理接口
abstract class PlatformViewEventDelegate {
  /// 当PlatformView的内容尺寸发生变化时调用
  void onContentSizeChanged(int viewId, double width, double height);
  
  /// 当PlatformView加载完成时调用
  void onContentLoaded(int viewId);
  
  /// 当PlatformView发生错误时调用
  void onError(int viewId, String error);
}

/// 统一平台视图入口
///
/// 使用方式：
/// MopPlatformView(
///   viewType: 'native-view-android',
///   creationParams: {'foo': 'bar'},
///   eventDelegate: MyPlatformViewDelegate(),
/// )
class MopPlatformView extends StatefulWidget {
  final String viewType;
  final Map<String, dynamic>? creationParams;
  final MessageCodec<dynamic>? creationParamsCodec;
  final PlatformViewEventDelegate? eventDelegate;

  const MopPlatformView({
    Key? key,
    required this.viewType,
    this.creationParams,
    this.creationParamsCodec,
    this.eventDelegate,
  }) : super(key: key);

  static const String _unifiedRegistryViewType = 'com.finogeeks.mop/platform_view';

  @override
  State<MopPlatformView> createState() => _MopPlatformViewState();
}

class _MopPlatformViewState extends State<MopPlatformView> {
  static const String _unifiedRegistryViewType = 'com.finogeeks.mop/platform_view';
  static const EventChannel _platformViewEventChannel = 
      EventChannel('plugins.mop.finogeeks.com/mop_event');
  
  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPlatformViewEvents();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _listenToPlatformViewEvents() {
    _eventSubscription = _platformViewEventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map && event['channel'] == 'platform_view_events') {
          final eventData = event['body'];
          final eventType = event['event'];
          
          switch (eventType) {
            case 'contentSizeChanged':
              widget.eventDelegate?.onContentSizeChanged(
                eventData['viewId'] as int,
                (eventData['width'] as num).toDouble(),
                (eventData['height'] as num).toDouble(),
              );
              break;
            case 'onContentLoaded':
              widget.eventDelegate?.onContentLoaded(eventData['viewId'] as int);
              break;
            case 'onLoadError':
              widget.eventDelegate?.onError(
                eventData['viewId'] as int,
                eventData['errorMessage'] as String,
              );
              break;
          }
        }
      },
      onError: (error) {
        debugPrint('PlatformView event error: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final codec = widget.creationParamsCodec ?? const StandardMessageCodec();
    final params = {
      'viewType': widget.viewType,
      'params': widget.creationParams,
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _unifiedRegistryViewType,
        creationParams: params,
        creationParamsCodec: codec,
      );
    } else {
      // Android端暂时保持现有实现
      return PlatformViewLink(
        viewType: _unifiedRegistryViewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams creationParams0) {
          final controller = PlatformViewsService.initSurfaceAndroidView(
            id: creationParams0.id,
            viewType: _unifiedRegistryViewType,
            layoutDirection: TextDirection.ltr,
            creationParams: params,
            creationParamsCodec: codec,
          );
          controller.addOnPlatformViewCreatedListener(creationParams0.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    }
  }
}
