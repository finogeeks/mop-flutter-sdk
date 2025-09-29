# FinClip Flutter SDK 测试指南

## 测试覆盖情况

### 1. 手动测试页面
主要的功能测试页面位于：`example/lib/new_features_page.dart`

这个页面提供了所有新功能的交互式测试界面，包括：

#### ✅ 已实现的测试功能

1. **小程序预加载**
   - 批量下载小程序测试
   - 返回结果显示（appId、success、needUpdate）

2. **搜索小程序**
   - 输入搜索关键词
   - 显示搜索结果列表
   - 高亮信息展示

3. **最近使用的小程序**
   - 获取并显示最近使用列表
   - 列表项可点击打开

4. **finfile路径转换**
   - 输入finfile路径
   - 转换为绝对路径
   - 显示转换结果

5. **生成finfile路径**
   - 生成TMP类型路径
   - 生成USR类型路径
   - 支持自定义文件名

6. **小程序收藏功能**
   - 添加收藏测试
   - 取消收藏测试
   - 查询收藏状态
   - 获取收藏列表

7. **移动小程序到前台**（仅Android）
   - 移动当前小程序到前台

### 2. 如何运行测试

#### 运行手动测试界面

```bash
# 进入example目录
cd example

# 安装依赖
flutter pub get

# iOS运行
flutter run -d ios

# Android运行
flutter run -d android
```

运行后，在主界面点击"新功能测试"按钮进入测试页面。

### 3. 测试注意事项

#### Android平台特殊说明
- **收藏功能**：Android SDK的收藏相关API只能操作当前打开的小程序，不支持指定appletId
- **移动到前台**：仅Android平台支持

#### iOS平台特殊说明
- **收藏功能**：iOS支持指定appletId操作任意小程序的收藏状态
- **移动到前台**：iOS不支持此功能，会返回错误提示

#### 枚举值对应关系
FinFilePathType枚举已调整为与iOS原生SDK一致：
- TMP = 0 (临时目录)
- STORE = 1 (存储目录)
- USR = 2 (用户目录)

### 4. API测试要点

#### 测试环境配置
- API服务器：`https://api.finclip.com`
- 测试小程序ID示例：
  - `5f72e3559a6a7900019b5baa`
  - `5f17f457297b540001e06ebb`

#### 参数验证
每个API都应测试以下场景：
1. 正常参数调用
2. 空参数/缺失参数
3. 错误参数类型
4. 边界值测试

#### 返回值验证
检查返回数据结构是否符合预期：
- 列表类型是否正确
- 字段是否完整
- null值处理是否正确

### 5. 灰度扩展测试

灰度扩展功能通过AppletHandler接口实现，需要在应用中实现`getGrayExtension`方法：

```dart
class MyAppletHandler extends AppletHandler {
  @override
  Future<Map<String, dynamic>?> getGrayExtension(String appletId) {
    // 返回灰度配置
    return Future.value({
      'grayType': 1,
      'grayPriority': ['version1', 'version2'],
      'grayList': ['user1', 'user2']
    });
  }

  // 实现其他必要方法...
}
```

### 6. 问题排查

如遇到问题，请检查：

1. **原生SDK版本**：确保Android和iOS的FinClip SDK已更新到支持这些功能的版本
2. **权限配置**：检查AndroidManifest.xml和Info.plist中的权限配置
3. **初始化状态**：确保SDK已正确初始化后再调用API
4. **网络连接**：部分功能需要网络连接

### 7. 已知限制

1. Android平台的收藏功能只能操作当前小程序
2. iOS平台不支持moveAppletToFront功能
3. finfile路径生成后，文件不会自动创建，需要手动写入内容

## 联系支持

如有问题，请联系FinClip技术支持团队。