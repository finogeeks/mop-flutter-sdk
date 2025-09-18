//
//  MOP_getFavoriteApplets.m
//  mop
//

#import "MOP_getFavoriteApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_getFavoriteApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.apiServer) {
        failure(@"Missing apiServer parameter");
        return;
    }

    int pageNo = (int)self.pageNo;
    int pageSize = (int)self.pageSize;

    [[FATClient sharedClient] getAppletFavoriteListWithApiServer:self.apiServer
                                                           pageNo:pageNo
                                                         pageSize:pageSize
                                                       completion:^(NSDictionary *resultDict, FATError *error) {
        if (error) {
            failure(error.localizedDescription);
        } else {
            // 直接返回原始数据
            success(resultDict ?: @{});
        }
    }];
}

@end