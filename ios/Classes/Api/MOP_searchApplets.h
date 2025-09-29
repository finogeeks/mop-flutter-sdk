//
//  MOP_searchApplets.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_searchApplets : MOPBaseApi

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *apiServer;

@end

NS_ASSUME_NONNULL_END