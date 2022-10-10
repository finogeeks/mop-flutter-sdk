//
//  MOP_currentApplet.m
//  mop
//
//  Created by 康旭耀 on 2020/4/16.
//

#import "MOP_currentApplet.h"

#import <FinApplet/FinApplet.h>

@implementation MOP_currentApplet


- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    FATAppletInfo *info = [[FATClient sharedClient] currentApplet];
    if(info != nil)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"appId"] = info.appId;
        dic[@"name"]= info.appTitle;
        dic[@"icon"]= info.appAvatar;
        dic[@"description"]=info.appDescription;
        dic[@"version"] = info.appVersion;
        dic[@"thumbnail"]=info.appThumbnail;
        dic[@"wechatLoginInfo"]=info.wechatLoginInfo;
        if (info.appletVersionType == FATAppletVersionTypeRelease) {
            dic[@"appletType"] = @"release";
        } else if (info.appletVersionType == FATAppletVersionTypeTrial) {
            dic[@"appletType"] = @"trial";
        } else if (info.appletVersionType == FATAppletVersionTypeTemporary) {
            dic[@"appletType"] = @"temporary";
        } else if (info.appletVersionType == FATAppletVersionTypeReview) {
            dic[@"appletType"] = @"review";
        } else {
            dic[@"appletType"] = @"development";
        }
        success(dic);
    } else {
        success(@{});
    }
}

+ (void)load {
    
}

@end
