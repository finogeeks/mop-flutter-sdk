//
//  MOP_sdkVersion.m
//  mop
//
//  Created by 康旭耀 on 2020/7/22.
//

#import "MOP_sdkVersion.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_sdkVersion

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"sdkVersion");
    NSString *version = [[FATClient sharedClient] version];
    success(version);
}

@end
