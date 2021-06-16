//
//  MOP_scanOpenApplet.m
//  mop
//
//  Created by beetle_92 on 2021/6/7.
//

#import "MOP_scanOpenApplet.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_scanOpenApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    NSLog(@"MOP_scanOpenApplet：%@", self.info);
    FATAppletDecryptRequest *req = [[FATAppletDecryptRequest alloc] init];
    req.info = self.info;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *currentVC = [MOPTools topViewController];
        [[FATClient sharedClient] startAppletWithDecryptRequest:req InParentViewController:currentVC completion:^(BOOL result, FATError *error) {
            NSLog(@"打开小程序:%@", error);
        } closeCompletion:^{
            NSLog(@"关闭小程序");
        }];
    });
    
}

@end
