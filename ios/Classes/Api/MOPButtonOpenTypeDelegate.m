//
//  MOPButtonOpenTypeDelegate.m
//  mop
//
//  Created by vhcan on 2023/6/28.
//

#import "MOPButtonOpenTypeDelegate.h"
#import "MopPlugin.h"
#import "MopCustomMenuModel.h"
#import <mop/MOPTools.h>
#import <objc/runtime.h>

@implementation MOPButtonOpenTypeDelegate

+ (instancetype)instance
{
    static MOPButtonOpenTypeDelegate *_instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (BOOL)getUserProfileWithAppletInfo:(FATAppletInfo *)appletInfo
                  bindGetUserProfile:(void (^)(NSDictionary *result))bindGetUserProfile
{
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:getUserProfile"
                arguments:nil
                   result:^(id result) {
        bindGetUserProfile ? bindGetUserProfile(result) : nil;
    }];
    return YES;
}

@end
