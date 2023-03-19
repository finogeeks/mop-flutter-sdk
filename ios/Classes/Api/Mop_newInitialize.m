//
//  Mop_newInitialize.m
//  mop
//
//  Created by 滔 on 2023/3/17.
//

#import "Mop_newInitialize.h"
#import "MOPTools.h"

@implementation Mop_newInitialize

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    if (!self.config) {
        failure(@"config不能为空");
        return;
    }
    FATConfig *config;
    NSArray *storeConfigList = self.config[@"storeConfigs"];
    if (storeConfigList && storeConfigList.count > 0) {
        NSMutableArray *storeArrayM = [NSMutableArray array];
        for (NSDictionary *dict in storeConfigList) {
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
        failure(@"storeConfigs不能为空");
        return;
    }
    
    config.currentUserId = self.config[@"currentUserId"];
    config.productIdentification = self.config[@"productIdentification"];
    config.disableAuthorize = [self.config[@"disableAuthorize"] boolValue];
    config.appletAutoAuthorize = [self.config[@"appletAutoAuthorize"] boolValue];
    config.disableGetSuperviseInfo = [self.config[@"disableGetSuperviseInfo"] boolValue];
    config.ignoreWebviewCertAuth = [self.config[@"ignoreWebviewCertAuth"] boolValue];
    config.appletIntervalUpdateLimit = [self.config[@"appletIntervalUpdateLimit"] integerValue];
    config.startCrashProtection = [self.config[@"startCrashProtection"] boolValue];
    config.enableApmDataCompression = [self.config[@"enableApmDataCompression"] boolValue];
    config.encryptServerData = [self.config[@"encryptServerData"] boolValue];
    config.enableAppletDebug = [self.config[@"enableAppletDebug"] integerValue];
    config.enableWatermark = [self.config[@"enableWatermark"] boolValue];
    config.watermarkPriority = [self.config[@"watermarkPriority"] integerValue];
    config.baseLoadingViewClass = self.config[@"baseLoadingViewClass"];
    config.baseLoadFailedViewClass = self.config[@"baseLoadFailedViewClass"];
    config.header = self.config[@"header"];
    config.headerPriority = [self.config[@"headerPriority"] integerValue];
    config.enableH5AjaxHook = [self.config[@"enableH5AjaxHook"] boolValue];
    config.h5AjaxHookRequestKey = self.config[@"h5AjaxHookRequestKey"];
    config.pageCountLimit = [self.config[@"pageCountLimit"] integerValue];
    config.schemes = self.config[@"schemes"];
    
    
    NSError* error = nil;
    FATUIConfig *uiconfig = [[FATUIConfig alloc]init];
    uiconfig.autoAdaptDarkMode = YES;
    if (_uiConfig) {
        if (_uiConfig[@"navigationTitleTextAttributes"]) {
            uiconfig.navigationTitleTextAttributes = _uiConfig[@"navigationTitleTextAttributes"];
        }
        
        uiconfig.navigationBarHeight = [_uiConfig[@"navigationBarHeight"] floatValue];
        if (_uiConfig[@"navigationBarTitleLightColor"]) {
            uiconfig.navigationBarTitleLightColor = [MOPTools colorWithRGBHex:[_uiConfig[@"navigationBarTitleLightColor"] intValue]];
        }
        if (_uiConfig[@"navigationBarTitleDarkColor"]) {
            uiconfig.navigationBarTitleDarkColor = [MOPTools colorWithRGBHex:[_uiConfig[@"navigationBarTitleDarkColor"] intValue]];
        }
        if (_uiConfig[@"navigationBarBackBtnLightColor"]) {
            uiconfig.navigationBarBackBtnLightColor = [MOPTools colorWithRGBHex:[_uiConfig[@"navigationBarBackBtnLightColor"] intValue]];
        }
        if (_uiConfig[@"navigationBarBackBtnDarkColor"]) {
            uiconfig.navigationBarBackBtnDarkColor = [MOPTools colorWithRGBHex:[_uiConfig[@"navigationBarBackBtnDarkColor"] intValue]];
        }
        uiconfig.moreMenuStyle = [_uiConfig[@"moreMenuStyle"] integerValue];
        uiconfig.hideBackToHomePriority = [_uiConfig[@"hideBackToHomePriority"] integerValue];
        uiconfig.hideFeedbackMenu = [_uiConfig[@"isHideFeedbackAndComplaints"] boolValue];
        uiconfig.hideBackToHome = [_uiConfig[@"isHideBackHome"] boolValue];
        uiconfig.hideForwardMenu = [_uiConfig[@"isHideForwardMenu"] boolValue];
//        uiconfig. = [_uiConfig[@"isHideRefreshMenu"] integerValue];
        uiconfig.moreMenuStyle = [_uiConfig[@"moreMenuStyle"] integerValue];
        uiconfig.moreMenuStyle = [_uiConfig[@"moreMenuStyle"] integerValue];
        if (_uiConfig[@"progressBarColor"]) {
            uiconfig.progressBarColor = [MOPTools colorWithRGBHex:[_uiConfig[@"progressBarColor"] intValue]];
        }
        
        uiconfig.hideFeedbackMenu = [_uiConfig[@"isHideFeedbackAndComplaints"] boolValue];
        uiconfig.hideForwardMenu = [_uiConfig[@"isHideForwardMenu"] boolValue];
        uiconfig.autoAdaptDarkMode = [_uiConfig[@"autoAdaptDarkMode"] boolValue];
        
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
        uiconfig.appendingCustomUserAgent = _uiConfig[@"customWebViewUserAgent"];
    }
    
    
    // uiconfig.moreMenuStyle = FATMoreViewStyleNormal;
    [[FATClient sharedClient] initWithConfig:config uiConfig:uiconfig error:&error];
    if (error) {
        failure(@"初始化失败");
        return;
    }
//    [[FATExtClient sharedClient] fat_prepareExtensionApis];
    [[FATClient sharedClient].logManager initLogWithLogDir:nil logLevel:FATLogLevelVerbose consoleLog:YES];
    
    
    [[FATClient sharedClient] setEnableLog:YES];
    
    success(@{});
    
}
@end
