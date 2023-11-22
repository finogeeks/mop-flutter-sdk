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
#import <objc/runtime.h>

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
        } else {
            completion(FATExtensionCodeSuccess,result);
        }
    }];
}

- (BOOL)appletInfo:(FATAppletInfo *)appletInfo didClickMoreBtnAtPath:(NSString *)path {
    NSLog(@"appletInfo:didClickMoreBtnAtPath");
    __block BOOL flag = NO;
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:customCapsuleMoreButtonClick" arguments:@{@"appId": appletInfo.appId} result:^(id _Nullable result) {
        if ([result isKindOfClass:[NSNumber class]]) {
            flag = [result boolValue];
        }
        CFRunLoopStop(CFRunLoopGetMain());
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFRunLoopStop(CFRunLoopGetMain());
    });
    CFRunLoopRun();
    return flag;
}

- (NSArray<id<FATAppletMenuProtocol>> *)customMenusInApplet:(FATAppletInfo *)appletInfo atPath:(NSString *)path {
    NSLog(@"customMenusInApplet");
    __block NSArray *list = @[];
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:getCustomMenus" arguments:@{@"appId": appletInfo.appId} result:^(id _Nullable result) {
        CFRunLoopStop(CFRunLoopGetMain());
        if ([result isKindOfClass:[NSArray class]]) {
            list = result;
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFRunLoopStop(CFRunLoopGetMain());
    });
    CFRunLoopRun();
    
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary<NSString *, NSString *> *data in list) {
        MopCustomMenuModel *model = [[MopCustomMenuModel alloc] init];
        model.menuId = data[@"menuId"];
        model.menuTitle = data[@"title"];
        NSString *imageUrl = data[@"image"];
        if ([imageUrl hasPrefix:@"http"]) {
            // 需要异步加载，待优化！
            model.menuIconUrl = imageUrl;
        } else {
            model.menuIconImage = [UIImage imageNamed:imageUrl];
        }
        NSString *darkImageUrl = data[@"darkImage"];
        if ([darkImageUrl hasPrefix:@"http"]) {
            model.menuDarkIconUrl = darkImageUrl;
        } else {
            model.menuIconDarkImage = [UIImage imageNamed:darkImageUrl];
        }
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
    NSError *parseError = nil;
    NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] initWithDictionary:[self dictionaryRepresentation:appletInfo]];
    [shareDic setValue:@{@"desc" : shareDic[@"originalInfo"][@"customData"][@"detailDescription"]} forKey:@"params"];
    [shareDic setValue:contentInfo[@"query"] forKey:@"query"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *arguments = @{
        @"appId": contentInfo[@"appId"],
        @"path": contentInfo[@"path"],
        @"menuId": contentInfo[@"menuId"],
        @"appInfo": jsonString
    };
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [channel invokeMethod:@"extensionApi:onCustomMenuClick" arguments:arguments result:^(id _Nullable result) {
        
    }];
    
    if ([@"Desktop" isEqualToString:contentInfo[@"menuId"]]) {
        [self addToDesktopItemClick:appletInfo path:contentInfo[@"path"]];
    }
}

- (NSDictionary *)dictionaryRepresentation:(FATAppletInfo *)object {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [object valueForKey:key];
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    free(properties);
    return dict;
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
    self.bindGetPhoneNumbers = bindGetPhoneNumber;
    NSLog(@"getPhoneNumberWithAppletInfo");
    [channel invokeMethod:@"extensionApi:getPhoneNumber" arguments:params result:^(id _Nullable result) {
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
