//
//  MOP_getUsedApplets.m
//  mop
//

#import "MOP_getUsedApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_getUsedApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    NSArray *usedApplets = [[FATClient sharedClient] getAppletsFromLocalCache];

    NSMutableArray *list = [NSMutableArray array];
    if (usedApplets && [usedApplets isKindOfClass:[NSArray class]]) {
        for (FATAppletInfo *appletInfo in usedApplets) {
            NSDictionary *dict = @{
                @"appId": appletInfo.appId ?: @"",
                @"appName": appletInfo.appTitle ?: @"",
                @"apiServer": appletInfo.apiServer ?: @"",
                @"frameworkVersion": appletInfo.libraryInfo.version ?: @"",
                @"logo": appletInfo.appAvatar,
                @"version": appletInfo.appVersion
            };
            [list addObject:dict];
        }
    }

    success(@{@"list": list});
}

@end
