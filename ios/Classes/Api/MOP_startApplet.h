//
//  MOP_openApplet.h
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_startApplet : MOPBaseApi

@property (nonatomic, copy) NSString *appletId;
@property (nonatomic, copy) NSString *apiServer;
@property (nonatomic, copy) NSString *sequence;
@property (nonatomic, copy) NSDictionary *startParams;
@property (nonatomic, copy) NSString *offlineMiniprogramZipPath;
@property (nonatomic, copy) NSString *offlineFrameworkZipPath;
@property (nonatomic, strong) NSString *animated;
@property (nonatomic, strong) NSString *transitionStyle;

@end

NS_ASSUME_NONNULL_END
