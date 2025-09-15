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
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"total"] = result[@"total"] ?: @0;

            NSMutableArray *list = [NSMutableArray array];
            NSArray *applets = result[@"list"];
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