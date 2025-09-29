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
    if (![NSThread currentThread].isMainThread) {
        [self _setupApiWithSuccess:success failure:failure cancel:cancel];
        return;
    }
    // 在后台线程执行耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self _setupApiWithSuccess:^(NSDictionary<NSString *,id> * _Nonnull data) {
            // 成功回调回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(data);
                }
            });
        } failure:^(id _Nullable error) {
            // 失败回调回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        } cancel:^{
            // 取消回调回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cancel) {
                    cancel();
                }
            });
        }];
    });
}

- (void)_setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
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
            success(@{@"list": results});
        }
    }];
}


@end
