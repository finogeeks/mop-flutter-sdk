//
//  MOP_openApplet.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_openApplet : MOPBaseApi

@property(nonatomic,copy)NSString* appId;
@property(nonatomic,copy)NSNumber* sequence;
@property(nonatomic,copy)NSDictionary* params;

@end

NS_ASSUME_NONNULL_END
