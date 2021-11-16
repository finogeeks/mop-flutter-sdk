//
//  MOP_webViewBounces.m
//  mop
//
//  Created by beetle_92 on 2021/11/16.
//

#import "MOP_webViewBounces.h"
#import "MOPTools.h"

@implementation MOP_webViewBounces

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    UIViewController *currentVC = [MOPTools topViewController];
    WKWebView *webView = [self searchWKWebView:currentVC.view];
    webView.scrollView.bounces = self.bounces;
}

- (WKWebView *)searchWKWebView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[WKWebView class]]) {
            return (WKWebView *)subview;
        }
        WKWebView *webView = [self searchWKWebView:subview];
        if (webView) {
            return webView;
        }
    }
    return nil;
}

@end
