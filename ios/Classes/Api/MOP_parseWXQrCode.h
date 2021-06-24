//
//  MOP_parseWXQrCode.h
//  mop
//
//  Created by EDY on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_parseWXQrCode : MOPBaseApi
@property(nonatomic,copy)NSString* qrCode; //二维码url
@property(nonatomic,copy)NSString* apiServer; //服务器地址
@end

NS_ASSUME_NONNULL_END
