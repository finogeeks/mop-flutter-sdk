//
//  MOP_registerExtensionApi.m
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import "MOP_registerExtensionApi.h"
#import "MopPlugin.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_registerExtensionApi

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"MOP_registerExtensionApi");
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [[FATClient sharedClient] registerExtensionApi:self.name handle:^(id param, FATExtensionApiCallback callback) {
        NSLog(@"invoke ExtensionApi:");
        NSLog(@"%@",self.name);
        NSLog(@"%@",param);
        NSString* api = [@"extensionApi:" stringByAppendingString:self.name];
        [channel invokeMethod:api arguments:param result:^(id  _Nullable result) {
            NSLog(@"extensionApi reslut:%@",result);
            BOOL isFlutterError = [result isKindOfClass:[FlutterError class]] || result == FlutterMethodNotImplemented;
            BOOL hasError = [[result allKeys] containsObject:@"errMsg"];
            if (isFlutterError || hasError) {
                NSLog(@"extensionApi reslut:fail");
                callback(FATExtensionCodeFailure,nil);
            } else {
                NSLog(@"extensionApi callback:%@",result);
                callback(FATExtensionCodeSuccess,result);
            }
        }];
    }];
    success(@{});
}

@end
