import 'dart:typed_data';

class CustomMenu {
  int menuId;
  String image;
  String title;

  Map<String, dynamic> toJson() =>
      {"menuId": menuId, "image": image, "title": title};
}

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
