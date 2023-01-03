//
//  MOPTools.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOPTools : NSObject
+ (UIViewController *)topViewController;
+  (UIViewController *)topViewController:(UIViewController *)rootViewController;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (UIColor *)fat_colorWithHexString:(NSString *)hexColor;

+ (BOOL)fat_currentLanguageIsEn;

///  设置颜色( + 暗黑模式)：UIDynamicProviderColor（会随着暗黑模式/明亮模式切换自动变化颜色）
/// @param lightHexString (明亮模式 的颜色值)
/// @param darkHexString (暗黑模式 的颜色值)
+ (UIColor *)fat_dynamicColorWithLightHexString:(NSString *)lightHexString darkHexString:(NSString *)darkHexString;


/// 获取当前页面的截图
+ (UIImage *)currentPageAppletImage;


/// 生成image对象
/// @param view 指定的view
+ (UIImage *)snapshotWithView:(UIView *)view;


/// 根据链接生成二维码图片
/// @param string 二维码的内容
+ (UIImage *)makeQRCodeForString:(NSString *)string;

+ (UIImage *)imageWithScreenshot;
@end

NS_ASSUME_NONNULL_END
