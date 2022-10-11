//
//  MOPAppletDelegate.h
//  mop
//
//  Created by 康旭耀 on 2020/4/20.
//

#import <Foundation/Foundation.h>
#import <FinApplet/FinApplet.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOPAppletDelegate : NSObject<FATAppletDelegate>

+ (instancetype)instance;

@property (nonatomic, copy) void (^bindGetPhoneNumbers)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
