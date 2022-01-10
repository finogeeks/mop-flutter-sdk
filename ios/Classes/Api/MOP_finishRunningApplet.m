//
//  MOP_finishRunningApplet.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOP_finishRunningApplet.h"

@implementation MOP_finishRunningApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appletId || self.appletId.length < 1) {
        failure(@{@"errMsg": @"finishRunningApplet:fail"});
        return;
    }
    [[FATClient sharedClient] closeApplet:self.appletId animated:_animated completion:^{
        [[FATClient sharedClient] clearMemeryApplet:self.appletId];
        success(@{});
    }];
    
}

@end
