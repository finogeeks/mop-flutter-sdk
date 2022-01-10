//
//  MOP_initialize.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import <UIKit/UIKit.h>
#import "MOPBaseApi.h"
NS_ASSUME_NONNULL_BEGIN

@interface MOP_initialize : MOPBaseApi

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *apiServer;
@property (nonatomic, copy) NSString *apiPrefix;
@property (nonatomic, copy) NSString *cryptType;
@property (nonatomic, assign) BOOL encryptServerData;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSArray *finStoreConfigs;
@property (nonatomic, strong) NSDictionary *uiConfig;
@property (nonatomic, copy) NSString *customWebViewUserAgent;
@property (nonatomic, assign) BOOL disablePermission;
@property (nonatomic, assign) NSInteger appletIntervalUpdateLimit;
@property (nonatomic, assign) NSInteger maxRunningApplet;


@end

NS_ASSUME_NONNULL_END
