//
//  MOP_scanOpenApplet.m
//  mop
//
//  Created by beetle_92 on 2021/6/7.
//

#import "MOP_qrcodeOpenApplet.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_qrcodeOpenApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    NSLog(@"MOP_qrcodeOpenApplet:%@", self.qrcode);
    FATAppletQrCodeRequest *qrcodeRequest = [[FATAppletQrCodeRequest alloc] init];
    qrcodeRequest.qrCode = self.qrcode;
    qrcodeRequest.reLaunchMode = [self.reLaunchMode intValue];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *currentVC = [MOPTools topViewController];
        [[FATClient sharedClient] startAppletWithQrCodeRequest:qrcodeRequest inParentViewController:currentVC requestBlock:^(BOOL result, FATError *error) {
            NSLog(@"请求完成：%@", error);
        } completion:^(BOOL result, FATError *error) {
            NSLog(@"打开完成：%@", error);
            if (result){
                success(@{});
            } else {
                failure(error.localizedDescription);
            }
        } closeCompletion:^{
            NSLog(@"关闭");
        }];
    });
    
}

@end
