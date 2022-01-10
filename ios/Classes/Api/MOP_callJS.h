//
//  MOP_callJS.h
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_callJS : MOPBaseApi
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *nativeViewId;
@property (nonatomic, copy) NSDictionary *eventData;
@end

NS_ASSUME_NONNULL_END
