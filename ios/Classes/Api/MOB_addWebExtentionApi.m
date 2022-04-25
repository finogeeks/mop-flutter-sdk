//
//  MOB_addWebExtentionApi.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOB_addWebExtentionApi.h"
#import "MopPlugin.h"
#import <FinApplet/FinApplet.h>

@implementation MOB_addWebExtentionApi

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"MOB_addWebExtentionApi");
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [[FATClient sharedClient] fat_registerWebApi:self.name handle:^(id param, FATExtensionApiCallback callback) {
        NSLog(@"invoke webExtentionApi:");
        NSLog(@"%@",self.name);
        NSLog(@"%@",param);
        NSString* api = [@"webExtentionApi:" stringByAppendingString:self.name];
        [channel invokeMethod:api arguments:param result:^(id  _Nullable result) {
            NSLog(@"webExtentionApi reslut:%@",result);
            // 先判断是否flutter发生错误
            BOOL isFlutterError = [result isKindOfClass:[FlutterError class]] || result == FlutterMethodNotImplemented;
            if (isFlutterError) {
                NSLog(@"webExtentionApi reslut:fail");
                callback(FATExtensionCodeFailure,nil);
                return;
            }
            // 再判断回调是否为失败
            BOOL hasError = [[result allKeys] containsObject:@"errMsg"];
            if (hasError) {
                NSString *errMsg = result[@"errMsg"];
                NSString *errPrefix = [NSString stringWithFormat:@"%@:fail", self.name];
                BOOL isFail = [errMsg hasPrefix:errPrefix];
                if (isFail) {
                    NSLog(@"webExtentionApi reslut:fail");
                    callback(FATExtensionCodeFailure,nil);
                    return;
                }
            }
            // 其他的按成功处理
            NSLog(@"webExtentionApi callback:%@",result);
            callback(FATExtensionCodeSuccess,result);
        }];

    }];
    success(@{});
    
}
@end
