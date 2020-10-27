//
//  MOP_openApplet.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOP_openApplet.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_openApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    UIViewController *currentVC = [MOPTools topViewController];

    // 打开小程序
    if (self.sequence == nil) {
    [[FATClient sharedClient] startRemoteApplet:self.appId startParams:self.params InParentViewController:currentVC completion:^(BOOL result, NSError *error) {
        NSLog(@"result:%d---error:%@", result, error);
        if (result){
            success(@{});
        }else {
            failure(error.description);
        }
    }];
    }else{
        [[FATClient sharedClient] startRemoteApplet:self.appId startParams:nil InParentViewController:currentVC completion:^(BOOL result, NSError *error) {
            NSLog(@"result:%d---error:%@", result, error);
            if (result){
                success(@{});
            }else {
                failure(error.description);
            }
        }];
        
    }
}
@end
