//
//  MOP_getFinFileAbsolutePath.m
//  mop
//

#import "MOP_getFinFileAbsolutePath.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_getFinFileAbsolutePath

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.finFilePath) {
        failure(@"Missing finFilePath parameter");
        return;
    }

    NSString *absolutePath = [[FATClient sharedClient] absolutePathWithAppletId:self.appId
                                                                     finFilePath:self.finFilePath
                                                                    needFileExist:self.needFileExist];

    if (absolutePath) {
        success(@{@"path": absolutePath});
    } else {
        failure(@"Failed to convert finfile path");
    }
}

@end