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
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"total"] = resultDict[@"total"] ?: @0;
            dict[@"pageNo"] = resultDict[@"pageNo"] ?: @(pageNo);
            dict[@"pageSize"] = resultDict[@"pageSize"] ?: @(pageSize);

            NSMutableArray *list = [NSMutableArray array];
            NSArray *applets = resultDict[@"list"];
            if (applets && [applets isKindOfClass:[NSArray class]]) {
                for (NSDictionary *appletInfo in applets) {
                    NSMutableDictionary *appletDict = [NSMutableDictionary dictionary];
                    appletDict[@"appId"] = appletInfo[@"appId"] ?: @"";
                    appletDict[@"appName"] = appletInfo[@"appName"] ?: @"";
                    appletDict[@"desc"] = appletInfo[@"desc"] ?: @"";
                    appletDict[@"logo"] = appletInfo[@"logo"] ?: @"";
                    appletDict[@"organName"] = appletInfo[@"organName"] ?: @"";
                    appletDict[@"pageUrl"] = appletInfo[@"pageUrl"] ?: @"";
                    appletDict[@"showText"] = appletInfo[@"showText"] ?: @"";

                    // 处理高亮信息
                    NSMutableArray *highLights = [NSMutableArray array];
                    NSArray *hlArray = appletInfo[@"highLights"];
                    if (hlArray && [hlArray isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *hl in hlArray) {
                            NSDictionary *hlDict = @{
                                @"key": hl[@"key"] ?: @"",
                                @"value": hl[@"value"] ?: @""
                            };
                            [highLights addObject:hlDict];
                        }
                    }
                    appletDict[@"highLights"] = highLights;

                    [list addObject:appletDict];
                }
            }
            dict[@"list"] = list;

            success(dict);
        }
    }];
}

@end