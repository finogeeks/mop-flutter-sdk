//
//  MOP_closeAllApplets.m
//  mop
//
//  Created by 康旭耀 on 2020/4/16.
//

#import "MOP_closeAllApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_closeAllApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"closeAllApplets");
    [[FATClient sharedClient] closeAllApplets];
    success(@{});
}

@end
