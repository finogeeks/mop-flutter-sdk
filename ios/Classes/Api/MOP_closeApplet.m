//
//  MOP_closeApplet.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOP_closeApplet.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_closeApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appletId || self.appletId.length < 1) {
        failure(@{@"errMsg": @"closeApplet:fail"});
        return;
    }
    [[FATClient sharedClient] closeApplet:self.appletId animated:_animated completion:^{
        success(@{});
    }];
    
}

@end
