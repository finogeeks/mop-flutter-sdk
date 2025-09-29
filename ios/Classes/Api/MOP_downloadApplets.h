//
//  MOP_downloadApplets.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_downloadApplets : MOPBaseApi

@property (nonatomic, strong) NSArray *appIds;
@property (nonatomic, copy) NSString *apiServer;
@property (nonatomic, assign) BOOL isBatchDownload;

@end

NS_ASSUME_NONNULL_END