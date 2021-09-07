//
//  MOP_removeUsedApplet.m
//  mop
//
//  Created by EDY on 2021/9/3.
//

#import "MOP_removeUsedApplet.h"

@implementation MOP_removeUsedApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"begin");
    if (!self.param || !self.param[@"appId"]) {
        NSLog(@"removeUsedApplet失败打印");
        failure(@{@"errMsg": @"removeUsedApplet:fail 2"});
        return;
    }
    [[FATClient sharedClient] removeAppletFromLocalCache:self.param[@"appId"]];
    NSLog(@"removeUsedApplet成功回调");
    success(@{});
}
@end
