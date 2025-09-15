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
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"appId"] = appletInfo.appId ?: @"";
            dict[@"name"] = appletInfo.appTitle ?: @"";
            dict[@"icon"] = appletInfo.appIcon ?: @"";
            dict[@"description"] = appletInfo.appDescription ?: @"";
            dict[@"version"] = appletInfo.appVersion ?: @"";
            dict[@"thumbnail"] = appletInfo.appThumbnail ?: @"";
            [list addObject:dict];
        }
    }

    success(@{@"data": list});
}

@end