//
//  MOP_initialize.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOP_initialize.h"
#import <FinApplet/FinApplet.h>
#import <FinAppletExt/FinAppletExt.h>
#import "MOPTools.h"

@implementation MOP_initialize

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.appkey || !self.secret) {
        failure(@"sdkkey 或 secret不能为空");
        return;
    }
    if (!self.apiServer || [self.apiServer isEqualToString:@""]) {
        self.apiServer = @"https://api.finclip.com";
    }
    if (!self.apiPrefix|| [self.apiPrefix isEqualToString:@""]) {
        self.apiPrefix = @"/api/v1/mop";
    }
    FATConfig *config;
    if (_finStoreConfigs && _finStoreConfigs.count > 0) {
        NSMutableArray *storeArrayM = [NSMutableArray array];
        for (NSDictionary *dict in _finStoreConfigs) {
            FATStoreConfig *storeConfig = [[FATStoreConfig alloc] init];
            storeConfig.sdkKey = dict[@"sdkKey"];
            storeConfig.sdkSecret = dict[@"sdkSecret"];
            storeConfig.apiServer = dict[@"apiServer"];
            storeConfig.apmServer = dict[@"apmServer"];
            storeConfig.fingerprint = dict[@"fingerprint"];
            if ([@"SM" isEqualToString:dict[@"cryptType"]]) {
                storeConfig.cryptType = FATApiCryptTypeSM;
            } else {
                storeConfig.cryptType = FATApiCryptTypeMD5;
            }
            storeConfig.encryptServerData = [dict[@"encryptServerData"] boolValue];
            [storeArrayM addObject:storeConfig];
        }
        config = [FATConfig configWithStoreConfigs:storeArrayM];
    } else {
        config = [FATConfig configWithAppSecret:self.secret appKey:self.appkey];
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
        
        // encryptServerData
        NSLog(@"encryptServerData:%d",self.encryptServerData);
        config.encryptServerData = self.encryptServerData;
    }
    
    NSLog(@"disablePermission:%d",self.disablePermission);
    config.disableAuthorize = self.disablePermission;
    config.currentUserId = [self.userId copy];
    config.appletIntervalUpdateLimit = self.appletIntervalUpdateLimit;
    
//    bool debug = false,
//    bool bindAppletWithMainProcess = false,
//    List<FinStoreConfig>? finStoreConfigs,
//    UIConfig? uiConfig,
//    String? customWebViewUserAgent,
//    int appletIntervalUpdateLimit = 0,
//    int maxRunningApplet = 5,

    NSError* error = nil;
    FATUIConfig *uiconfig = [[FATUIConfig alloc]init];
    if (_uiConfig) {
        if (_uiConfig[@"navigationTitleTextAttributes"]) {
            uiconfig.navigationTitleTextAttributes = _uiConfig[@"navigationTitleTextAttributes"];
        }
        if (_uiConfig[@"webViewProgressBarColor"]) {
            uiconfig.progressBarColor = [MOPTools colorWithRGBHex:[_uiConfig[@"webViewProgressBarColor"] intValue]];
        }
        uiconfig.hideFeedbackMenu = [_uiConfig[@"isHideFeedbackAndComplaints"] boolValue];
        uiconfig.hideForwardMenu = [_uiConfig[@"isHideForwardMenu"] boolValue];
        uiconfig.autoAdaptDarkMode = [_uiConfig[@"autoAdaptDarkMode"] boolValue];
        uiconfig.hideShareAppletMenu = [_uiConfig[@"isHideShareAppletMenu"] boolValue];
        uiconfig.appletText = _uiConfig[@"appletText"];
        uiconfig.hideTransitionCloseButton = [_uiConfig[@"hideTransitionCloseButton"] boolValue];
        uiconfig.disableSlideCloseAppletGesture = [_uiConfig[@"disableSlideCloseAppletGesture"] boolValue];
        if (_uiConfig[@"capsuleConfig"]) {
            NSDictionary *capsuleConfigDic = _uiConfig[@"capsuleConfig"];
            FATCapsuleConfig *capsuleConfig = [[FATCapsuleConfig alloc]init];
            capsuleConfig.capsuleWidth = [capsuleConfigDic[@"capsuleWidth"] floatValue];
            capsuleConfig.capsuleHeight = [capsuleConfigDic[@"capsuleHeight"] floatValue];
            capsuleConfig.capsuleRightMargin = [capsuleConfigDic[@"capsuleRightMargin"] floatValue];
            capsuleConfig.capsuleCornerRadius = [capsuleConfigDic[@"capsuleCornerRadius"] floatValue];
            capsuleConfig.capsuleBorderWidth = [capsuleConfigDic[@"capsuleBorderWidth"] floatValue];
            capsuleConfig.moreBtnWidth = [capsuleConfigDic[@"moreBtnWidth"] floatValue];
            capsuleConfig.moreBtnLeftMargin = [capsuleConfigDic[@"moreBtnLeftMargin"] floatValue];
            capsuleConfig.closeBtnWidth = [capsuleConfigDic[@"closeBtnWidth"] floatValue];
            capsuleConfig.closeBtnLeftMargin = [capsuleConfigDic[@"closeBtnLeftMargin"] floatValue];
            
            
            capsuleConfig.capsuleBorderLightColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleBorderLightColor"] intValue]];
            capsuleConfig.capsuleBorderDarkColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleBorderDarkColor"] intValue]];
            capsuleConfig.capsuleBgLightColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleBgLightColor"] intValue]];
            capsuleConfig.capsuleBgDarkColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleBgDarkColor"] intValue]];
            capsuleConfig.capsuleDividerLightColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleDividerLightColor"] intValue]];
            capsuleConfig.capsuleDividerDarkColor = [MOPTools colorWithRGBHex:[capsuleConfigDic[@"capsuleDividerDarkColor"] intValue]];
            uiconfig.capsuleConfig = capsuleConfig;
            
        }
        
    }
    uiconfig.appendingCustomUserAgent = self.customWebViewUserAgent;
    
    // uiconfig.moreMenuStyle = FATMoreViewStyleNormal;
    [[FATClient sharedClient] initWithConfig:config uiConfig:uiconfig error:&error];
    if (error) {
        failure(@"初始化失败");
        return;
    }
//    [[FATExtClient sharedClient] fat_prepareExtensionApis];
    [[FATClient sharedClient].logManager initLogWithLogDir:nil logLevel:FATLogLevelVerbose consoleLog:YES];
    
    success(@{});
    
    
}
@end
