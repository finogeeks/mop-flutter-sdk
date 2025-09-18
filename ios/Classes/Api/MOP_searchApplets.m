//
//  MOP_searchApplets.m
//  mop
//

#import "MOP_searchApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_searchApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.text || !self.apiServer) {
        failure(@"Missing required parameters");
        return;
    }

    FATSearchAppletRequest *searchRequest = [[FATSearchAppletRequest alloc] init];
    searchRequest.apiServer = self.apiServer;
    searchRequest.text = self.text;

    [[FATClient sharedClient] searchAppletsWithRequest:searchRequest
                                             completion:^(NSDictionary *result, FATError *aError) {
        if (aError) {
            failure(aError.localizedDescription);
        } else {
            // 直接返回原始数据
            success(result ?: @{});
        }
    }];
}

@end