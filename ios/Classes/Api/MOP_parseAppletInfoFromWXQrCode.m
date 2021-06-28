//
//  MOP_parseWXQrCode.m
//  mop
//
//  Created by EDY on 2021/6/22.
//

#import "MOP_parseAppletInfoFromWXQrCode.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_parseAppletInfoFromWXQrCode

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    NSLog(@"MOP_parseWXQrCode：%@", self.qrCode);
    [[FATClient sharedClient] parseAppletInfoFromWXQrCode:self.qrCode apiServer:self.apiServer completion:^(FATAppletSimpleInfo *appInfo, FATError *aError) {
        if (aError) {
            failure(aError.description);
        }else{
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
            if (appInfo && appInfo.appId) {
                [dataDic setObject:appInfo.appId forKey:@"appId"];
            }
            success(dataDic);
        }
    }];
}

@end
