//
//  MOP_getFavoriteApplets.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_getFavoriteApplets : MOPBaseApi

@property (nonatomic, copy) NSString *apiServer;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END