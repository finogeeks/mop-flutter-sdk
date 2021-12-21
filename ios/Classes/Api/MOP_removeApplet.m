//
//  MOP_removeApplet.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOP_removeApplet.h"

@implementation MOP_removeApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appletId || self.appletId.length < 1) {
        failure(@{@"errMsg": @"removeApplet:fail"});
        return;
    }
    FATAppletInfo *appletInfo = [[FATClient sharedClient] currentApplet];
    if (appletInfo && [appletInfo.appId isEqual:self.appletId]) {
        [[FATClient sharedClient] closeApplet:self.appletId animated:NO completion:^{
            [[FATClient sharedClient] removeAppletFromLocalCache:self.appletId];
            success(@{});
        }];
    } else {
        [[FATClient sharedClient] removeAppletFromLocalCache:self.appletId];
        success(@{});
    }
    
    
    
}
@end
