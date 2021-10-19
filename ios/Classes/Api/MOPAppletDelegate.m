//
//  MOPAppletDelegate.m
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import "MOPAppletDelegate.h"
#import "MopPlugin.h"
#import "MopCustomMenuModel.h"

@implementation MOPAppletDelegate

+ (instancetype)instance
{
    static MOPAppletDelegate *_instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)forwardAppletWithInfo:(NSDictionary *)contentInfo completion:(void (^)(FATExtensionCode, NSDictionary *))completion
{
    NSLog(@"forwardAppletWithInfo1:%@",contentInfo);
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:forwardApplet" arguments:@{@"appletInfo":contentInfo} result:^(id  _Nullable result) {
        if([result isKindOfClass:[FlutterError class]]|| [result isKindOfClass:[FlutterMethodNotImplemented class] ])
        {
            completion(FATExtensionCodeFailure,nil);
        }else
        {
            completion(FATExtensionCodeSuccess,result);
        }
    }];
}

- (NSDictionary *)getUserInfoWithAppletInfo:(FATAppletInfo *)appletInfo
{
    NSLog(@"getUserInfoWithAppletInfo");
    __block NSDictionary *userInfo;
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:getUserInfo" arguments:nil result:^(id _Nullable result) {
        CFRunLoopStop(CFRunLoopGetMain());
        userInfo = result;
    }];
    CFRunLoopRun();
    return userInfo;
}

- (NSArray<id<FATAppletMenuProtocol>> *)customMenusInApplet:(FATAppletInfo *)appletInfo atPath:(NSString *)path {
    NSLog(@"customMenusInApplet");
    __block NSArray *list;
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:getCustomMenus" arguments:@{@"appId": appletInfo.appId} result:^(id _Nullable result) {
        CFRunLoopStop(CFRunLoopGetMain());
        list = result;
    }];
    CFRunLoopRun();
    
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary<NSString *, NSString *> *data in list) {
        MopCustomMenuModel *model = [[MopCustomMenuModel alloc] init];
        model.menuId = data[@"menuId"];
        model.menuTitle = data[@"title"];
        model.menuIconImage = [UIImage imageNamed:data[@"image"]];
        NSString *typeString = data[@"type"];
        if (typeString) {
            FATAppletMenuStyle style = [typeString isEqualToString:@"onMiniProgram"] ? FATAppletMenuStyleOnMiniProgram : FATAppletMenuStyleCommon;
            model.menuType = style;
        }
        [models addObject:model];
    }
    
    return models;
}

- (void)customMenu:(id<FATAppletMenuProtocol>)customMenu inApplet:(FATAppletInfo *)appletInfo didClickAtPath:(NSString *)path {
    NSDictionary *arguments = @{
        @"appId": appletInfo.appId,
        @"path": path,
        @"menuId": customMenu.menuId,
        @"appInfo": appletInfo.description
    };
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:onCustomMenuClick" arguments:arguments result:^(id _Nullable result) {
        
    }];
}

- (void)clickCustomItemMenuWithInfo:(NSDictionary *)contentInfo completion:(void (^)(FATExtensionCode code, NSDictionary *result))completion {
    NSDictionary *arguments = @{
        @"appId": contentInfo[@"appId"],
        @"path": contentInfo[@"path"],
        @"menuId": contentInfo[@"menuId"],
        @"appInfo": [NSString stringWithFormat:@"{'title': '%@', 'description': '%@', 'imageUrl': '%@'}", contentInfo[@"title"], contentInfo[@"description"], contentInfo[@"imageUrl"]]
    };
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:onCustomMenuClick" arguments:arguments result:^(id _Nullable result) {
        
    }];
}

- (void)applet:(NSString *)appletId didOpenCompletion:(NSError *)error {
    if (!appletId) {
        return;
    }
    NSDictionary *params = @{@"appId":appletId};
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:appletDidOpen" arguments:params result:^(id _Nullable result) {
        
    }];
}

@end
