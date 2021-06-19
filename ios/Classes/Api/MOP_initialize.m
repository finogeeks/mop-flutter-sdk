//
//  MOP_initialize.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOP_initialize.h"
#import <FinApplet/FinApplet.h>
#import <FinAppletExt/FinAppletExt.h>

@implementation MOP_initialize

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appkey || !self.secret) {
        failure(@"appkey 或 secret不能为空");
        return;
    }
    if (!self.apiServer || [self.apiServer isEqualToString:@""]) {
        self.apiServer = @"https://api.finclip.com";
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
    config.currentUserId = [self.userId copy];
    
    NSLog(@"disablePermission:%d",self.disablePermission);
    config.disableAuthorize = self.disablePermission;
    NSError* error = nil;
    FATUIConfig *uiconfig = [[FATUIConfig alloc]init];
    uiconfig.autoAdaptDarkMode = YES;
    // uiconfig.moreMenuStyle = FATMoreViewStyleNormal;
    [[FATClient sharedClient] initWithConfig:config uiConfig:uiconfig error:&error];
    if (error) {
        failure(@"初始化失败");
        return;
    }
    [[FATExtClient sharedClient] fat_prepareExtensionApis];
    [[FATClient sharedClient] setEnableLog:YES];
    success(@{});
    
    
}
@end
