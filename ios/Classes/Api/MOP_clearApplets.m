//
//  MOP_clearApplets.m
//  mop
//
//  Created by 康旭耀 on 2020/4/16.
//

#import "MOP_clearApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_clearApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"clearApplets");
    [[FATClient sharedClient] closeAllAppletsWithCompletion:^{
        [[FATClient sharedClient] clearMemoryCache];
        success(@{});
    }];
}

@end
