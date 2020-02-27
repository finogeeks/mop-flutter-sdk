//
//  MOPBaseApi.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOPBaseApi : NSObject

/**
 api名称
 */
@property (nonatomic, readonly, copy) NSString * _Null_unspecified command;

/**
 原始参数
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nullable param;


/**
 设置API, 子类重写
 
 @param success 成功回调
 @param failure 失败回调
 @param cancel 取消回调
 */
- (void)setupApiWithSuccess:(void(^_Null_unspecified)(NSDictionary<NSString *, id> * _Nonnull))success
                    failure:(void(^_Null_unspecified)(id _Nullable))failure
                     cancel:(void(^_Null_unspecified)(void))cancel;
@end

NS_ASSUME_NONNULL_END
