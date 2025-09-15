//
//  MOP_downloadApplets.m
//  mop
//

#import "MOP_downloadApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_downloadApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.appIds || !self.apiServer) {
        failure(@"Missing required parameters");
        return;
    }

    BOOL batchDownload = self.isBatchDownload;

    [[FATClient sharedClient] downloadApplets:self.appIds
                                     apiServer:self.apiServer
                       isBatchDownloadApplets:batchDownload
                                      complete:^(NSArray *results, FATError *error) {
        if (error) {
            failure(error.localizedDescription);
        } else {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *info in results) {
                
                NSString *appId = info[@"appId"];
                NSNumber *success = info[@"success"];
                NSNumber *needUpdate = info[@"needUpdate"];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];

                if ([appId isKindOfClass:NSString.class]) {
                    dict[@"appId"] = appId;
                }
                if ([success isKindOfClass:NSNumber.class]) {
                    dict[@"success"] = success;
                }
                if ([needUpdate isKindOfClass:NSNumber.class]) {
                    dict[@"needUpdate"] = needUpdate;
                }
                [list addObject:dict];
            }
            success(@{@"data": list});
        }
    }];
}

@end
