//
//  MOPApiConverter.m
//  mop
//
//  Created by 杨涛 on 2020/2/27.
//

#import "MOPApiConverter.h"
#import <objc/runtime.h>

@implementation MOPApiConverter
+ (MOPBaseApi*)apiWithRequest:(MOPApiRequest*)request
{
    
    NSString* command = request.command;
    NSDictionary* param = request.param;
    
    //自动生成类名
    NSString *apiMethod = [NSString stringWithFormat:@"MOP_%@",command];
    Class ApiClass = NSClassFromString(apiMethod);
    
    if (!ApiClass) {
        NSLog(@"MOPybridExtensionConverter Error %@",apiMethod);
        return nil;
    }
    
    MOPBaseApi *api = [[ApiClass alloc] init];
    [api setValue:command forKey:@"command"];
    [api setValue:param forKey:@"param"];
    
    NSDictionary *propertyMap = @{};
    NSArray *mapToKeys = propertyMap.allValues;
    for (NSString *datakey in param.allKeys) {
        @autoreleasepool {
            __block NSString *propertyKey = datakey;
            if (propertyMap && [mapToKeys containsObject:datakey]) {
                [propertyMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    if (key.length && [obj isEqualToString:datakey]) {
                        propertyKey = key;
                        *stop = YES;
                    }
                }];
            }
            
            objc_property_t property = class_getProperty([api class], [propertyKey UTF8String]);
            if (!property) {
//                NSlog(@"找不到对应的属性，需要留意...");
                continue;
            }
            
            id value = [param objectForKey:datakey];
            id safetyValue = [self parseFromKeyValue:value];
            if (safetyValue) {
                [api setValue:safetyValue forKey:propertyKey];
            }
        }
    }
    return api;
}

#pragma mark - moved from WDDataSecurityManager

// 作空值过滤处理-任意对象
+ (id)parseFromKeyValue:(id)value {
    //值无效
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) { //统一处理为字符串
        value = [NSString stringWithFormat:@"%@",value];
    } else if ([value isKindOfClass:[NSArray class]]) { //数组
        value = [self parseFromArray:value];
    } else if ([value isKindOfClass:[NSDictionary class]]) { //字典
        value = [self parseFromDictionary:value];
    }
    
    return value;
}


// 作空值过滤处理-字典对象
+ (NSDictionary *)parseFromDictionary:(NSDictionary *)container {
    if ([container isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *result = [NSMutableDictionary new];
        for (id key in container.allKeys) {
            @autoreleasepool {
                id value = container[key];
                
                id safetyValue = [self parseFromKeyValue:value];
                if (!safetyValue) //如果safetyValue是字典或者数组类型，为nil值时设置成空字符串会产生崩溃
                {
//                    safetyValue = @"";
                    continue;
                }
                [result setObject:safetyValue forKey:key];
            }
        }
        return result;
    }
    return container;
}


// 作空值过滤处理-数组对象
+ (NSArray *)parseFromArray:(NSArray *)container {
    if ([container isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [NSMutableArray new];
        for (int i = 0; i < container.count; i++) {
            @autoreleasepool {
                id value = container[i];
                
                id safetyValue = [self parseFromKeyValue:value];
                if (!safetyValue) {
                    safetyValue = @"";
                }
                
                [result addObject:safetyValue];
            }
        }
        
        return result;
    }
    
    return container;
}
@end
