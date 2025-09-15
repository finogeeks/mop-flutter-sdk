/// finfile路径类型
enum FinFilePathType {
  USR,   // 用户目录 - 持久化，可自定义路径
  TMP,   // 临时目录 - 冷启动时清除
  STORE  // 存储目录 - 持久化
}

class CustomMenu {
  String menuId;
  String image;
  String? darkImage;
  String title;
  String type;

  CustomMenu(this.menuId, this.image, this.title, this.type);

  Map<String, dynamic> toJson() =>
      {'menuId': menuId, 'image': image, 'darkImage': darkImage, 'title': title, 'type': type};
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

  /// 是否自定义胶囊里更多按钮的点击事件（该代理方法只对iOS端生效）
  bool customCapsuleMoreButtonClick(String appId);

  /// 获取自定义菜单
  Future<List<CustomMenu>> getCustomMenus(String appId);

  ///自定义菜单点击处理
  Future<void> onCustomMenuClick(
      String appId, String path, String menuId, String appInfo);

  ///打开小程序
  Future<void> appletDidOpen(String appId);

  ///getMobileNumber
  Future<void> getMobileNumber(Function(dynamic params) param0);

  /// 获取灰度扩展参数
  /// [appletId] 小程序ID
  /// 返回灰度配置Map
  Future<Map<String, dynamic>?> getGrayExtension(String appletId) {
    return Future.value(null);
  }
}
