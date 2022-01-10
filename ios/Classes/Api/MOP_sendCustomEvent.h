//
//  MOP_sendCustomEvent.h
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_sendCustomEvent : MOPBaseApi
@property (nonatomic, strong) NSDictionary *eventData;
@end

NS_ASSUME_NONNULL_END
