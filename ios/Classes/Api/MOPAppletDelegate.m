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
    [channel invokeMethod:@"extensionApi:getUserInfo" arguments:nil result:^(id  _Nullable result) {
          userInfo = result;
    }];
    return userInfo;
}

- (NSArray<id<FATAppletMenuProtocol>> *)customMenusInApplet:(FATAppletInfo *)appletInfo atPath:(NSString *)path {
    MopCustomMenuModel *favModel1 = [[MopCustomMenuModel alloc] init];
    favModel1.menuId = @"WXShareAPPFriends";
    favModel1.menuTitle = @"微信好友";
    favModel1.menuIconImage = [UIImage imageNamed:@"mini_menu_chat"];
    favModel1.menuType = FATAppletMenuStyleOnMiniProgram;
    
    MopCustomMenuModel *favModel2 = [[MopCustomMenuModel alloc] init];
    favModel2.menuId = @"ShareSinaWeibo";
    favModel2.menuTitle = @"新浪微博";
    favModel2.menuIconImage = [UIImage imageNamed:@"mini_menu_chat"];
    favModel2.menuType = FATAppletMenuStyleOnMiniProgram;
    
    MopCustomMenuModel *favModel3 = [[MopCustomMenuModel alloc] init];
    favModel3.menuId = @"Restart";
    favModel3.menuTitle = @"重启";
    favModel3.menuIconImage = [UIImage imageNamed:@"minipro_list_setting"];
    favModel3.menuType = FATAppletMenuStyleCommon;
    
    MopCustomMenuModel *favModel4 = [[MopCustomMenuModel alloc] init];
    favModel4.menuId = @"ShareQQFriends";
    favModel4.menuTitle = @"QQ好友";
    favModel4.menuIconImage = [UIImage imageNamed:@"minipro_list_setting"];
    favModel4.menuType = FATAppletMenuStyleOnMiniProgram;
    
    return @[favModel1, favModel2, favModel3, favModel4];
}

- (void)clickCustomItemMenuWithInfo:(NSDictionary *)contentInfo completion:(void (^)(FATExtensionCode code, NSDictionary *result))completion {
    
}

@end
