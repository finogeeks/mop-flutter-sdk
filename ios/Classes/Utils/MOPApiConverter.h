//
//  MOPApiConverter.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import <Foundation/Foundation.h>
#import "MOPApiRequest.h"
#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOPApiConverter : NSObject
+ (MOPBaseApi*)apiWithRequest:(MOPApiRequest*)request;

@end

NS_ASSUME_NONNULL_END
