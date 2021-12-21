//
//  MOP_finishRunningApplet.h
//  mop
//
//  Created by 王滔 on 2021/12/21.
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_finishRunningApplet : MOPBaseApi
@property (nonatomic, copy) NSString appletId;
@property (nonatomic, assign) BOOL animated;
@end

NS_ASSUME_NONNULL_END
