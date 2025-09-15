//
//  MOP_updateAppletFavorite.h
//  mop
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_updateAppletFavorite : MOPBaseApi

@property (nonatomic, copy) NSString *appletId;
@property (nonatomic, assign) BOOL favorite;

@end

NS_ASSUME_NONNULL_END