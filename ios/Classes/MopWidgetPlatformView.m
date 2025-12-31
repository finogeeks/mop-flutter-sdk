#import "MopWidgetPlatformView.h"
#import <FinApplet/FinApplet.h>
#import "MopPlugin.h"


@interface MopWidgetPlatformView () <FATWidgetViewDelegate> {
    UIView *_view;
    NSString *_externalViewType;
    NSDictionary *_params;
    NSObject<FlutterBinaryMessenger>* _messenger;
    int64_t _viewId;
}
@end

@implementation MopWidgetPlatformView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
        _viewId = viewId;
        _view = [[UIView alloc] initWithFrame:frame];
        
        if ([args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)args;
            id vt = dict[@"viewType"]; if ([vt isKindOfClass:[NSString class]]) { _externalViewType = vt; }
            id p = dict[@"params"]; if ([p isKindOfClass:[NSDictionary class]]) { _params = p; }
            
            if (p[@"appId"]) {
                
                NSString *apiServer = p[@"apiServer"] != NULL ? p[@"apiServer"] : @"";
                [self openWidget:p[@"appId"] apiServer:apiServer enableMultiWidget:p[@"enableMultiWidget"] != NULL forceUpdate:p[@"forceUpdate"] != NULL];
                
            } else if (p[@"qrCode"]) {
                
                [self openWidgetWithQR:p[@"qrCode"] forceUpdate: p[@"forceUpdate"] != NULL];
            } else {
                
                NSLog(@"fincli 打开小组件报错：%@", error);
                MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
                NSDictionary *eventData = @{
                    @"viewId": @(self->_viewId),
                    @"eventType": @"onLoadError",
                    @"errorMessage": @"MopWidgetPlatformView: no appId or qrCode found"
                };
                
                [eventStream send:@"platform_view_events" event:@"onLoadError" body:eventData];
                NSLog(@"你需要传入小组件的 appId 或着小组件的二维码");
            }
        }
    }
    return self;
}


- (UIView *)view {
    return _view;
}

- (void)openWidget:(NSString *)appId apiServer:(NSString *)apiserver enableMultiWidget:(Boolean)enableMultiWidget forceUpdate:(Boolean)forceUpdate{
    FATWidgetRequest *widgetRequest = [[FATWidgetRequest alloc]init];
    widgetRequest.widgetId = appId;
    widgetRequest.widgetServer = apiserver;
    widgetRequest.enableMultiWidget = enableMultiWidget;
    widgetRequest.forceUpdate = forceUpdate;
    
  
    [[FATClient sharedClient].widgetManager createWidget:widgetRequest parentViewController:[[UIApplication sharedApplication] fat_topViewController] completion:^(FATWidgetView * _Nullable widgetView, FATError * _Nonnull error) {
        NSLog(@"fincli 打开小组件");
        if (!error) {
            if (widgetView) {
                widgetView.delegate = self;
                [self showWidgetView:widgetView];

                MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
                NSDictionary *eventData = @{
                    @"viewId": @(self->_viewId),
                    @"message": @"widget loaded successfully",
                    @"eventType": @"onContentLoaded"
                };
                [eventStream send:@"platform_view_events" event:@"onContentLoaded" body:eventData];
                
            }
        }else {
            NSLog(@"fincli 打开小组件报错：%@", error);
            MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
            NSDictionary *eventData = @{
                @"viewId": @(self->_viewId),
                @"eventType": @"onLoadError",
                @"error": @"widget failed to load",
                @"errorCode": @(error.code),
                @"errorMessage": error.localizedDescription ?: @"Unknown error"
            };
            
            [eventStream send:@"platform_view_events" event:@"onLoadError" body:eventData];
        }
    }];
}

- (void)openWidgetWithQR:(NSString *)qrCode forceUpdate:(Boolean)forceUpdate{
    FATWidgetQRCodeRequest *qrCodeRequest = [[FATWidgetQRCodeRequest alloc]init];
    qrCodeRequest.qrCode = qrCode;
    qrCodeRequest.forceUpdate = forceUpdate;
  
    [[FATClient sharedClient].widgetManager createWidgetWithQRCode:qrCodeRequest parentViewController:[[UIApplication sharedApplication] fat_topViewController] completion:^(FATWidgetView * _Nullable widgetView, FATError *error) {
        if (!error) {
            if (widgetView) {
                widgetView.delegate = self;
                [self showWidgetView:widgetView];

                MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
                NSDictionary *eventData = @{
                    @"viewId": @(self->_viewId),
                    @"message": @"widget loaded successfully",
                    @"eventType": @"onContentLoaded"
                };
                
                [eventStream send:@"platform_view_events" event:@"onContentLoaded" body:eventData];
            
               
            }
        } else {
            NSLog(@"fincli 打开小组件报错：%@", error);

            MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
            NSDictionary *eventData = @{
                @"viewId": @(self->_viewId),
                @"eventType": @"onLoadError",
                @"error": @"widget failed to load",
                @"errorCode": @(error.code),
                @"errorMessage": error.localizedDescription ?: @"Unknown error"
            };
            
            [eventStream send:@"platform_view_events" event:@"onLoadError" body:eventData];
        }
    }];
}

- (void)showWidgetView:(FATWidgetView *)widgetView {
    [_view addSubview:widgetView];

    widgetView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    widgetView.layoutMargins = UIEdgeInsetsMake(50, 50, 50, 50);
    [_view addConstraints:@[topLayoutConstraint,leftLayoutConstraint,rightLayoutConstraint,bottomLayoutConstraint]];

}


- (void)onWidgetView:(nonnull FATWidgetView *)widgetView contentSizeUpdate:(CGSize)size { 
    // 通过代理发送事件到Flutter
    MopEventStream *eventStream = [[MopPlugin instance] mopEventStreamHandler];
    NSDictionary *eventData = @{
        @"viewId": @(_viewId),
        @"width": @(size.width),
        @"height": @(size.height),
        @"eventType": @"contentSizeChanged"
    };
    
    [eventStream send:@"platform_view_events" event:@"contentSizeChanged" body:eventData];
}

@end
