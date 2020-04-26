//
//  MOPAppletDelegate.m
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import "MOPAppletDelegate.h"
#import "MopPlugin.h"

@implementation MOPAppletDelegate

- (void)forwardAppletWithInfo:(NSDictionary *)contentInfo completion:(void (^)(FATExtensionCode, NSDictionary *))completion
{
    NSLog(@"forwardAppletWithInfo:%@",contentInfo);
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:forwardApplet" arguments:contentInfo result:^(id  _Nullable result) {
        if([result isKindOfClass:[FlutterError class]]|| [result isKindOfClass:[FlutterMethodNotImplemented class] ])
        {
            completion(FATExtensionCodeFailure,nil);
        }else
        {
            completion(FATExtensionCodeSuccess,result);
        }
    }];
}

- (NSDictionary *)getUserInfoWithAppletInfo:(FATAppletInfo *)appletInfo
{
    NSLog(@"getUserInfoWithAppletInfo");
    __block NSDictionary *userInfo;
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [channel invokeMethod:@"extensionApi:getUserInfo" arguments:nil result:^(id  _Nullable result) {
        userInfo = result;
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return userInfo;
}

- (NSArray<id<FATAppletMenuProtocol>> *)customMenusInMoreItemAtPath:(NSString *)path
{
    return nil;
}

- (void)customMenu:(id<FATAppletMenuProtocol>)customMenu didClickAtPath:(NSString *)path
{
    
}

@end
