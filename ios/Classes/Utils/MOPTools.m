//
//  MOPTools.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOPTools
+ (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int a = (hex >> 24) & 0xFF;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

+ (UIColor *)fat_colorWithHexString:(NSString *)hexColor {
    if (!hexColor) return nil;
    // 兼容black和white
    if ([hexColor compare:@"black" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return UIColor.blackColor;
    } else if ([hexColor compare:@"white" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return UIColor.whiteColor;
    }

    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if (cString.length == 0) return nil;
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString containsString:@"0X"]) cString = [cString stringByReplacingOccurrencesOfString:@"0X" withString:@""];

    if (cString.length == 3) { // 3位转成6位
        cString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                                             [cString characterAtIndex:0],
                                             [cString characterAtIndex:0],
                                             [cString characterAtIndex:1],
                                             [cString characterAtIndex:1],
                                             [cString characterAtIndex:2],
                                             [cString characterAtIndex:2]];
    }
    if (cString.length == 4) { // 4位转为8位
        cString = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c",
                                             [cString characterAtIndex:0],
                                             [cString characterAtIndex:0],
                                             [cString characterAtIndex:1],
                                             [cString characterAtIndex:1],
                                             [cString characterAtIndex:2],
                                             [cString characterAtIndex:2],
                                             [cString characterAtIndex:3],
                                             [cString characterAtIndex:3]];
    }

    NSScanner *scanner = [NSScanner scannerWithString:cString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return [UIColor blackColor];

    if (cString.length == 6) {
        return [self fat_colorWithRGBHex:hexNum];
    } else if (cString.length == 8) {
        return [self fat_colorWithARGBHex:hexNum];
    }
    return nil;
}

+ (UIColor *)fat_colorWithRGBHex:(UInt32)hex {
    int red = (hex >> 16) & 0xFF;
    int green = (hex >> 8) & 0xFF;
    int blue = (hex)&0xFF;
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

+ (UIColor *)fat_colorWithRGBAlphaHex:(UInt32)hex {
    int red = (hex >> 24) & 0xFF;
    int green = (hex >> 16) & 0xFF;
    int blue = (hex >> 8) & 0xFF;
    int alpha = hex & 0xFF;
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

+ (UIColor *)fat_colorWithARGBHex:(UInt32)hex {
    int alpha = (hex >> 24) & 0xFF;
    int red = (hex >> 16) & 0xFF;
    int green = (hex >> 8) & 0xFF;
    int blue = hex & 0xFF;
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

+ (BOOL)fat_currentLanguageIsEn {
    NSString *languageCode = [NSLocale preferredLanguages].firstObject; // 返回的是国际通用语言Code+国际通用国家地区代码
    if ([languageCode hasPrefix:@"zh"]) {
        return NO;
    }
    return YES;
}

///  设置颜色( + 暗黑模式)
/// @param lightHexString (明亮模式 的颜色值)
/// @param darkHexString (暗黑模式 的颜色值)
+ (UIColor *)fat_dynamicColorWithLightHexString:(NSString *)lightHexString darkHexString:(NSString *)darkHexString {
    return [self fat_dynamicColorWithLight:[UIColor fat_colorWithRGBAHexString:lightHexString] darkColor:[UIColor fat_colorWithRGBAHexString:darkHexString]];
}

+ (UIColor *)fat_dynamicColorWithLight:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (!darkColor) {
        return lightColor;
    }
    BOOL autoAdaptDarkMode = [FATClient sharedClient].uiConfig.autoAdaptDarkMode;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsupported-availability-guard"
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
    if (@available(iOS 13.0, *) && autoAdaptDarkMode) {
        return [UIColor colorWithDynamicProvider:^UIColor *_Nonnull(UITraitCollection *_Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
#pragma clang diagnostic pop
                return darkColor;
            } else {
                return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}

+ (UIImage *)snapshotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (UIImage *)makeQRCodeForString:(NSString *)string {
    NSString *text = string;
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    //二维码颜色
    UIColor *onColor = [UIColor whiteColor];
    UIColor *offColor = [UIColor blackColor];
    //上色，如果只要白底黑块的QRCode可以跳过这一步
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                          keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    //绘制
    CIImage *qrImage = colorFilter.outputImage;
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage  fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);//生成的QRCode就是上下颠倒的,需要翻转一下
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);

    return [UIImage imageWithCIImage:qrImage];
}


/// 顶部状态栏高度（包括安全区）
+ (CGFloat)getStatusHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (UIImage *)getCurrentPageImage {
    UIViewController *currentVC = [MOPTools topViewController];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(currentVC.view.frame.size.width, 440), NO, [UIScreen mainScreen].scale);
    [currentVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

// 截取当前屏幕 ,返回截取到的图片
//+ (UIImage *)getCurrentPageImage {
//
//
//    CGSize imageSize = CGSizeZero;
//
//
//
//
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//        imageSize = [UIScreen mainScreen].bounds.size;
//    } else {
//        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    }
//    // 绘制上下文
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, window.center.x, window.center.y);
//        CGContextConcatCTM(context, window.transform);
//        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//        if (orientation == UIInterfaceOrientationLandscapeLeft) {
//            CGContextRotateCTM(context, M_PI_2);
//            CGContextTranslateCTM(context, 0, -imageSize.width);
//        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
//            CGContextRotateCTM(context, -M_PI_2);
//            CGContextTranslateCTM(context, -imageSize.height, 0);
//        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//            CGContextRotateCTM(context, M_PI);
//            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
//        }
//        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
//            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//        } else {
//            [window.layer renderInContext:context];
//        }
//        CGContextRestoreGState(context);
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(image);
//    return [UIImage imageWithData:imageData];
//}



@end
