class CustomMenu {
  String menuId;
  String image;
  String title;
  String type;

  CustomMenu(this.menuId, this.image, this.title, this.type);

  Map<String, dynamic> toJson() =>
      {'menuId': menuId, 'image': image, 'title': title, 'type': type};
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
  Future<void> onCustomMenuClick(
      String appId, String path, String menuId, String appInfo, String query);

  ///打开小程序
  Future<void> appletDidOpen(String appId);

  ///getMobileNumber
  Future<void> getMobileNumber(Function(dynamic params) param0);
}
