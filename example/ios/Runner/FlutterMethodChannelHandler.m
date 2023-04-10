//
//  FlutterMethodChannelHandler.m
//  Runner
//
//  Created by Haley on 2023/4/10.
//

#import "FlutterMethodChannelHandler.h"

#import <FinApplet/UIApplication+FATPublic.h>

@interface FlutterMethodChannelHandler ()

@property (nonatomic,strong) FlutterMethodChannel *channel;

@end

@implementation FlutterMethodChannelHandler

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    self = [super init];
    if (self) {
        [self setupChannelWithMessenger:messenger];
    }
    
    return self;
}

- (void)setupChannelWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{
    _channel = [FlutterMethodChannel methodChannelWithName:@"com.message.flutter_to_app" binaryMessenger:messenger];
    
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSLog(@"收到Flutter消息：%@", call.method);
        if ([call.method isEqualToString:@"showCustomMoreView"]) {
            NSString *appId = call.arguments[@"appId"];
            // 弹出自定义的更多视图
            UIViewController *viewController = [[UIApplication sharedApplication] fat_topViewController];
            
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"更多视图" message:appId preferredStyle:UIAlertControllerStyleActionSheet];
            [alertViewController addAction:[UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertViewController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [viewController presentViewController:alertViewController animated:YES completion:nil];
        }
    }];
}

@end
