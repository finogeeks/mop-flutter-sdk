//
//  Mop_initSDK.h
//  mop
//
//  Created by 滔 on 2023/3/17.
//

#import <UIKit/UIKit.h>
#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_initSDK : MOPBaseApi
@property (nonatomic, strong) NSDictionary *config;
@property (nonatomic, strong) NSDictionary *uiConfig;
@end

NS_ASSUME_NONNULL_END
