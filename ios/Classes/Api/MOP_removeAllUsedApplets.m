//
//  MOP_removeAllUsedApplets.m
//  mop
//
//  Created by 胡健辉 on 2022/5/20.
//

#import "MOP_removeAllUsedApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_removeAllUsedApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    NSLog(@"removeAllUsedApplets");
    [[FATClient sharedClient] clearLocalApplets];
    [[FATClient sharedClient] clearMemoryCache];
    success(@{});
}
@end
