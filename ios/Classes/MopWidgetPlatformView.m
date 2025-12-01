#import "MopWidgetPlatformView.h"
#import <FinApplet/FinApplet.h>


@interface MopWidgetPlatformView () {
    UIView *_view;
    NSString *_externalViewType;
    NSDictionary *_params;
    NSObject<FlutterBinaryMessenger>* _messenger;
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
        _view = [[UIView alloc] initWithFrame:frame];

        if ([args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)args;
            id vt = dict[@"viewType"]; if ([vt isKindOfClass:[NSString class]]) { _externalViewType = vt; }
            id p = dict[@"params"]; if ([p isKindOfClass:[NSDictionary class]]) { _params = p; }
            
            NSString *appId = p[@"appId"];
            NSString *apiServer;
            if (p[@"apiServer"] != NULL) {
                apiServer = p[@"apiServer"];
            }
            
            [self openWidget:appId apiServer:apiServer];
        }
    }
    return self;
}


- (UIView *)view {
    return _view;
}

- (void)openWidget:(NSString *)appId apiServer:(NSString *)apiserver {
    FATWidgetRequest *widgetRequest = [[FATWidgetRequest alloc]init];
    widgetRequest.widgetId = appId;
    widgetRequest.widgetServer = apiserver;
    
  
    [[FATClient sharedClient].widgetManager createWidget:widgetRequest parentViewController:[[UIApplication sharedApplication] fat_topViewController] completion:^(FATWidgetView * _Nullable widgetView, FATError * _Nonnull error) {
        NSLog(@"fincli 打开小组件");
        if (!error) {
            if (widgetView) {
                [self showWidgetView:widgetView];
            }
        }else {
            NSLog(@"fincli 打开小组件报错：");
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


@end
