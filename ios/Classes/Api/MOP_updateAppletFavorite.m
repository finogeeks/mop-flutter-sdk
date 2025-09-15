//
//  MOP_updateAppletFavorite.m
//  mop
//

#import "MOP_updateAppletFavorite.h"
#import <FinApplet/FinApplet.h>
#import <FinAppletExt/FinAppletExt.h>

@implementation MOP_updateAppletFavorite

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.appletId) {
        failure(@"Missing appletId parameter");
        return;
    }

    [FATMoreMenuHelper updateApplet:self.appletId
                      favoriteStatus:self.favorite
                        withComplete:^(NSError *error, FATAppletInfo *appletInfo) {
        if (error) {
            failure(error.localizedDescription);
        } else {
            success(@{});
        }
    }];
}

@end