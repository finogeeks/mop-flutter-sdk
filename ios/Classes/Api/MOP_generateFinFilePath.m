//
//  MOP_generateFinFilePath.m
//  mop
//

#import "MOP_generateFinFilePath.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_generateFinFilePath

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    if (!self.fileName) {
        failure(@"Missing fileName parameter");
        return;
    }

    FATFinFilePathType finPathType;
    switch (self.pathType) {
        case 0:  // TMP
            finPathType = FATFinFilePathTypeTmp;
            break;
        case 1:  // STORE
            finPathType = FATFinFilePathTypeStore;
            break;
        case 2:  // USR
            finPathType = FATFinFilePathTypeUsr;
            break;
        default:
            failure(@"Invalid pathType");
            return;
    }

    NSString *finFilePath = [[FATClient sharedClient] generateFinFilePath:self.fileName
                                                                  pathType:finPathType];

    if (finFilePath) {
        success(@{@"path": finFilePath});
    } else {
        failure(@"Failed to generate finfile path");
    }
}

@end