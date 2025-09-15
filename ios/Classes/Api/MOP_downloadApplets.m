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
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"appId"] = info[@"appId"] ?: @"";
                dict[@"success"] = info[@"success"] ?: @NO;
                if ([info[@"success"] boolValue]) {
                    dict[@"needUpdate"] = info[@"needUpdate"] ?: @NO;
                } else {
                    dict[@"needUpdate"] = [NSNull null];
                }
                [list addObject:dict];
            }
            success(@{@"data": list});
        }
    }];
}

@end