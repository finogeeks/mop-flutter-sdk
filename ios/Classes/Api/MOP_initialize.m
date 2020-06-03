//
//  MOP_initialize.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOP_initialize.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_initialize

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appkey || !self.secret) {
        failure(@"appkey 或 secret不能为空");
        return;
    }
    if (!self.apiServer || [self.apiServer isEqualToString:@""]) {
        self.apiServer = @"https://mp.finogeeks.com";
    }
    if (!self.apiPrefix|| [self.apiPrefix isEqualToString:@""]) {
        self.apiPrefix = @"/api/v1/mop";
    }
    FATConfig *config = [FATConfig configWithAppSecret:self.secret appKey:self.appkey];
    config.apiServer = [self.apiServer copy];
    config.apiPrefix = [self.apiPrefix copy];
    if([self.cryptType isEqualToString: @"SM"])
    {
        config.cryptType = FATApiCryptTypeSM;
    }
    else
    {
        config.cryptType = FATApiCryptTypeMD5;
    }
    config.autoAdaptDarkMode = YES;
    NSError* error = nil;
    [[FATClient sharedClient] initWithConfig:config error:&error];
    if (error) {
        failure(@"初始化失败");
        return;
    }
    success(@{});
    
    
}
@end
