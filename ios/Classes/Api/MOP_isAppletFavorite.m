//
//  MOP_isAppletFavorite.m
//  mop
//

#import "MOP_isAppletFavorite.h"
#import <FinApplet/FinApplet.h>
#import <FinAppletExt/FinAppletExt.h>

@implementation MOP_isAppletFavorite

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.appletId) {
        failure(@"Missing appletId parameter");
        return;
    }

    BOOL isFavorite = [FATMoreMenuHelper isAppletFavorite:self.appletId];

    success(@{@"favorite": @(isFavorite)});
}

@end