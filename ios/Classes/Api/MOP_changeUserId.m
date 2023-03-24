//
//  MOP_changeUserId.m
//  mop
//
//  Created by 滔 on 2023/3/23.
//

#import "MOP_changeUserId.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_changeUserId
- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    [FATClient sharedClient].config.currentUserId = self.userId;
    success(@{});
}
@end
