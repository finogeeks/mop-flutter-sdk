//
//  MOP_generateFinFilePath.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_generateFinFilePath : MOPBaseApi

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger pathType;

@end

NS_ASSUME_NONNULL_END