//
//  MOP_openApplet.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOP_startApplet.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_startApplet

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    UIViewController *currentVC = [MOPTools topViewController];

    FATAppletRequest *request = [[FATAppletRequest alloc] init];
    request.appletId = self.appletId;
    request.apiServer = self.apiServer;
    request.startParams = self.startParams;
    if (self.sequence){
        request.sequence = @([self.sequence intValue]);
    }
    request.offlineMiniprogramZipPath = self.offlineMiniprogramZipPath;
    request.offlineFrameworkZipPath = self.offlineFrameworkZipPath;
    request.animated = [self.animated boolValue];
    request.transitionStyle = [self.transitionStyle intValue];

    // 启动小程序
    [[FATClient sharedClient] startAppletWithRequest:request InParentViewController:currentVC completion:^(BOOL result, NSError *error) {
        if (result){
            success(@{});
        } else {
            failure(error.description);
        }
    } closeCompletion:^(void) {
        
    }];
}
@end
