//
//  MOP_callJS.m
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOP_callJS.h"

@implementation MOP_callJS

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.eventData || !self.eventName || !self.nativeViewId) {
        failure(@{@"errMsg": @"callJS:fail"});
        return;
    }
    
    NSNumber *numberId = @(_nativeViewId.integerValue);
    [[FATClient sharedClient].nativeViewManager sendEvent:_eventName nativeViewId:numberId detail:_eventData completion:^(id result, NSError *error) {
        if (error) {
            failure(@{@"errMsg": @"callJS:fail"});
        } else {
            success(result);
        }
    }];
}
@end
