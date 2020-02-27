//
//  MOPApiRequest.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOPApiRequest : NSObject

/**
 api方法
 */
@property (nonatomic, copy) NSString *command;

/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary *param;

@end

NS_ASSUME_NONNULL_END
