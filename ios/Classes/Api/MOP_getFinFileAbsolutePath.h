//
//  MOP_getFinFileAbsolutePath.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_getFinFileAbsolutePath : MOPBaseApi

@property (nonatomic, copy, nullable) NSString *appId;
@property (nonatomic, copy) NSString *finFilePath;
@property (nonatomic, assign) BOOL needFileExist;

@end

NS_ASSUME_NONNULL_END