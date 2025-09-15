//
//  MOP_getUsedApplets.m
//  mop
//

#import "MOP_getUsedApplets.h"
#import <FinApplet/FinApplet.h>

@implementation MOP_getUsedApplets

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success
                     failure:(void (^)(id _Nullable))failure
                      cancel:(void (^)(void))cancel {

    NSArray *usedApplets = [[FATClient sharedClient] getAppletsFromLocalCache];

    NSMutableArray *list = [NSMutableArray array];
    if (usedApplets && [usedApplets isKindOfClass:[NSArray class]]) {
        for (FATAppletInfo *appletInfo in usedApplets) {
            NSDictionary *dict = [appletInfo convertToDictionary];
            [list addObject:dict];
        }
    }

    success(@{@"data": list});
}

@end
