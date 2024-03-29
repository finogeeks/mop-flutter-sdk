//
//  LoadingView.m
//  Runner
//
//  Created by Haley on 2023/4/9.
//

#import "LoadingView.h"

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.loadingView.padding = 5;
        self.loadingView.dotView.backgroundColor = [UIColor redColor];
        self.loadingView.animation.duration = 2;
        self.titleLabel.textColor = [UIColor redColor];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 修改小程序logo应该是从管理后台上传新的小程序图标，因为更多面板、关于页面也会展示小程序logo，只改这里只是loding页面生效
    self.bottomImageView.hidden = YES;
}

@end
