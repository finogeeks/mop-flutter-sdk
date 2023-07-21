//
//  MOP_registerSyncExtensionApi.m
//  mop
//
//  Created by Stewen on 2023/6/30.
//

#import "MOP_registerSyncExtensionApi.h"
#import "MopPlugin.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_registerSyncExtensionApi

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"MOP_registerSyncExtensionApi,name=%@",self.name);
    FlutterMethodChannel *channel = [[MopPlugin instance] methodChannel];
    [[FATClient sharedClient] registerSyncExtensionApi:self.name handler:^NSDictionary *(FATAppletInfo *appletInfo, id param) {
        if([self.name isEqualToString:@"getLanguageCodeSync"]){
            NSString *languageCode = [[NSLocale preferredLanguages] firstObject];
            NSString *shortCode = [[NSLocale componentsFromLocaleIdentifier:languageCode] objectForKey:NSLocaleLanguageCode];
            NSString *countryCode = [NSString stringWithFormat:@"%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
            NSDictionary *resultDict = @{@"languageCode":shortCode,@"countryCode":countryCode};
            return resultDict;
        }
        return @{};
    }];
    success(@{});
}

@end
