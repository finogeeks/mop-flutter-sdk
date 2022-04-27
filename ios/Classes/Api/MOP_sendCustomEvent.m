//
//  MOP_sendCustomEvent.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOP_sendCustomEvent.h"

@implementation MOP_sendCustomEvent

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.eventData ) {
        failure(@{@"errMsg": @"sendCustomEvent:fail"});
        return;
    }
    if (!self.appId) {
        [[FATClient sharedClient].nativeViewManager sendCustomEventWithDetail:self.eventData completion:^(id result, NSError *error) {
            if (error) {
                failure(@{@"errMsg": @"sendCustomEvent:fail"});
            } else {
                success(result);
            }
        }];
    } else {
        [[FATClient sharedClient].nativeViewManager sendCustomEventWithDetail:self.eventData applet:self.appId completion:^(id result, FATError *error) {
            if (error) {
                failure(@{@"errMsg": @"sendCustomEvent:fail"});
            } else {
                success(result);
            }
        }];
    }
    
    
}
@end
