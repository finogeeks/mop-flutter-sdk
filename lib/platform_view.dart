import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 统一平台视图入口
///
/// 使用方式：
/// MopPlatformView(
///   viewType: 'native-view-android',
///   creationParams: {'foo': 'bar'},
/// )
class MopPlatformView extends StatelessWidget {
  final String viewType;
  final Map<String, dynamic>? creationParams;
  final MessageCodec<dynamic>? creationParamsCodec;

  const MopPlatformView({
    Key? key,
    required this.viewType,
    this.creationParams,
    this.creationParamsCodec,
  }) : super(key: key);

  static const String _unifiedRegistryViewType = 'com.finogeeks.mop/platform_view';

  @override
  Widget build(BuildContext context) {
    final codec = creationParamsCodec ?? const StandardMessageCodec();
    final params = {
      'viewType': viewType,
      'params': creationParams,
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      // 使用统一注册的 viewType，实际的原生视图类型通过 creationParams 传递
      return AndroidView(
        viewType: _unifiedRegistryViewType,
        creationParams: params,
        creationParamsCodec: codec,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _unifiedRegistryViewType,
        creationParams: params,
        creationParamsCodec: codec,
      );
    }
    return const Center(child: Text('当前平台不支持原生视图'));
  }
}
