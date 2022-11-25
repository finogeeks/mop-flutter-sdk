//
//  MOPAppletDelegate.m
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import "MOPAppletDelegate.h"
#import "MopPlugin.h"
#import "MopCustomMenuModel.h"
#import <mop/MOPTools.h>

@interface NSString (FATEncode)
- (NSString *)fat_encodeString;

@end


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
        if ([result isKindOfClass:[NSArray class]]) {
            list = result;
        }
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

- (void)clickCustomItemMenuWithInfo:(NSDictionary *)contentInfo inApplet:(FATAppletInfo *)appletInfo completion:(void (^)(FATExtensionCode code, NSDictionary *result))completion {
    NSDictionary *arguments = @{
        @"appId": contentInfo[@"appId"],
        @"path": contentInfo[@"path"],
        @"menuId": contentInfo[@"menuId"],
        @"appInfo": appletInfo.description
    };
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:onCustomMenuClick" arguments:arguments result:^(id _Nullable result) {
        
    }];
    
    if ([@"Desktop" isEqualToString:contentInfo[@"menuId"]]) {
        [self addToDesktopItemClick:appletInfo path:contentInfo[@"path"]];
    }
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

static NSString *scheme = @"fatae55433be2f62915";//App对应的scheme

- (void)addToDesktopItemClick:(FATAppletInfo *)appInfo path:(NSString *)path {
    NSMutableString *herf = [NSString stringWithFormat:@"%@://applet/appid/%@?", scheme, appInfo.appId].mutableCopy;
    NSString *query = [NSString stringWithFormat:@"apiServer=%@&path=%@",appInfo.apiServer, path];

    if ([appInfo.startParams[@"query"] length]) {
        query = [NSString stringWithFormat:@"%@&query=%@",query, appInfo.startParams[@"query"]];
    }
    [herf appendString:query.fat_encodeString];

    NSMutableString *url = [NSMutableString stringWithFormat:@"%@/mop/scattered-page/#/desktopicon", appInfo.apiServer];
    [url appendFormat:@"?iconpath=%@", appInfo.appAvatar];
    [url appendFormat:@"&apptitle=%@", appInfo.appTitle.fat_encodeString];
    [url appendFormat:@"&linkhref=%@", herf];
    
    NSLog(@"跳转到中间页面:%@", url);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)getPhoneNumberWithAppletInfo:(FATAppletInfo *)appletInfo bindGetPhoneNumber:(void (^)(NSDictionary *))bindGetPhoneNumber {
    NSDictionary *params = @{@"name":@"getPhoneNumber"};

    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:getPhoneNumber" arguments:params result:^(id _Nullable result) {
        self.bindGetPhoneNumbers = bindGetPhoneNumber;
//        !self.bindGetPhoneNumbers?: bindGetPhoneNumber(result);
    }];

}

- (void)chooseAvatarWithAppletInfo:(FATAppletInfo *)appletInfo bindChooseAvatar:(void (^)(NSDictionary *result))bindChooseAvatar {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *album = [MOPTools fat_currentLanguageIsEn] ? @"Album" : @"从相册选择";
    UIAlertAction *chooseAlbumAction = [UIAlertAction actionWithTitle:album style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSDictionary *params = @{@"name":@"chooseAvatarAlbum"};
        
        FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
        [channel invokeMethod:@"extensionApi:chooseAvatarAlbum" arguments:params result:^(id _Nullable result) {
            !bindChooseAvatar?: bindChooseAvatar(result);
        }];
    }];
    NSString *camera = [MOPTools fat_currentLanguageIsEn] ? @"Camera" : @"拍照";
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:camera style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSDictionary *params = @{@"name":@"chooseAvatarPhoto"};
        
        FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
        [channel invokeMethod:@"extensionApi:chooseAvatarPhoto" arguments:params result:^(id _Nullable result) {
            !bindChooseAvatar?: bindChooseAvatar(result);
        }];
    }];
    NSString *cancel = [MOPTools fat_currentLanguageIsEn] ? @"Cancel" : @"取消";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
        bindChooseAvatar(@{});
    }];
    [alertController addAction:chooseAlbumAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    UIViewController *topVC = [MOPTools topViewController];
    [topVC presentViewController:alertController animated:YES completion:nil];
}




@end

@implementation NSString (FATEncode)

- (NSString *)fat_encodeString {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( NULL,  (__bridge CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

@end
