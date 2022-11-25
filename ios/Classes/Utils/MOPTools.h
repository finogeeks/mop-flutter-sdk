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
@end

NS_ASSUME_NONNULL_END
