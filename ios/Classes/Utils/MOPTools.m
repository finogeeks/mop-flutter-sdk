//
//  MOPTools.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOPTools.h"

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


@end
