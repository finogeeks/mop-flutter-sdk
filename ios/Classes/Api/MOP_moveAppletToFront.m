//
//  MOP_moveAppletToFront.m
//  mop
//

#import "MOP_moveAppletToFront.h"

@implementation MOP_moveAppletToFront

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    // iOS不支持此功能
    failure(@"This feature is not supported on iOS platform");
}

@end