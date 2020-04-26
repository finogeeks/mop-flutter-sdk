//
//  MOP_registerAppletHandler.m
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import "MOP_registerAppletHandler.h"
#import "MopPlugin.h"
#import "MOPAppletDelegate.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_registerAppletHandler

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel
{
    NSLog(@"MOP_registerAppletHandler");
    [[FATClient sharedClient] setDelegate:[[MOPAppletDelegate alloc] init]];

}

@end
