//
//  MOP_smsign.m
//  mop
//
//  Created by beetle_92 on 2021/4/21.
//

#import "MOP_smsign.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_smsign

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"smsign");
    NSString *signature = [[FATClient sharedClient] getSM3String:self.plainText];
    NSLog(@"signature = %@", signature);
    success(@{@"data": signature});
}

@end
