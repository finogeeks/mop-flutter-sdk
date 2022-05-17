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
        success(dic);
    }
    else
    {
        success(@{});
    }
}

+ (void)load {
    
}

@end
