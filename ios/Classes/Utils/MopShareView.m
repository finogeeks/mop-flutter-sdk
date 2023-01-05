//
//  MopShareView.m
//  mop
//
//  Created by 王兆耀 on 2023/1/2.
//

#import "MopShareView.h"
#import "MopPlugin.h"
#import "MOPTools.h"
#import <FinApplet/FinApplet.h>
#import <UIView+MOPFATToast.h>

//获取安全区域距离
#define kFinoSafeAreaTop        kFinoWindowSafeAreaInset.top
#define kFinoSafeAreaBottom     kFinoWindowSafeAreaInset.bottom

#define kFinoWindowSafeAreaInset \
({\
UIEdgeInsets returnInsets = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);\
UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;\
if ([keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {\
UIEdgeInsets inset = [[keyWindow valueForKeyPath:@"safeAreaInsets"] UIEdgeInsetsValue];\
if (inset.top < [UIApplication sharedApplication].statusBarFrame.size.height) {\
inset.top = [UIApplication sharedApplication].statusBarFrame.size.height;\
}\
returnInsets = inset;\
}\
(returnInsets);\
})\

@interface MopShareView ()<UICollectionViewDelegate, UICollectionViewDataSource, MOPCellClickDelegate>


@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIImageView *appletImageView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation MopShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = @[@{@"lightImage":@"share_wechat", @"title":@"微信好友", @"type":@"wechat"},
                           @{@"lightImage":@"share_moments",@"title":@"朋友圈", @"type":@"moments"},
                           @{@"lightImage":@"share_link",@"title":@"复制链接", @"type":@"links"}];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        
        self.shareView = [[UIView alloc] initWithFrame:CGRectMake(52.5 , 46 + kFinoSafeAreaTop, 270, 380)];
        self.shareView.layer.cornerRadius = 6;
        self.shareView.backgroundColor = UIColor.whiteColor;

        UIImageView *appletImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 300)];
        appletImageView.contentMode = UIViewContentModeScaleToFill;
        self.appletImageView = appletImageView;
        [self.shareView addSubview:appletImageView];
                
        float bottomY = appletImageView.frame.size.height + appletImageView.frame.origin.y;
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.shareView.frame.size.width, 0.5)];
        line0.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#eeeeee" darkHexString:@"#eeeeee"];
        [self.shareView addSubview:line0];
        
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.frame = CGRectMake(14, bottomY + 12, 168, 21);
        descLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        descLabel.textColor = [MOPTools fat_dynamicColorWithLightHexString:@"#222222" darkHexString:@"#222222"];
        self.titleLabel = descLabel;
        [self.shareView addSubview:descLabel];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.frame = CGRectMake(14, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, 168, 44);
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.numberOfLines = 0;
        detailLabel.textColor = [MOPTools fat_dynamicColorWithLightHexString:@"#666666" darkHexString:@"#666666"];
        self.descLabel = detailLabel;
        [self.shareView addSubview:detailLabel];
        
        self.qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(196, bottomY + 8, 64, 64)];
        [self.shareView addSubview:self.qrCodeImageView];

        [self addSubview:self.shareView];

        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height - (221 + kFinoSafeAreaBottom) , self.frame.size.width, (221 + kFinoSafeAreaBottom))];
        self.contentView.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#F0F0F0" darkHexString:@"#1A1A1A"];
        [self addSubview:self.contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 58 )];
        titleLabel.text = @"分享至";
        titleLabel.textColor = [MOPTools fat_dynamicColorWithLightHexString:@"#222222" darkHexString:@"#D0D0D0"];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 58 , self.contentView.frame.size.width, 0.5)];
        line1.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#E0E0E0" darkHexString:@"#E0E0E0"];
        [self.contentView addSubview:line1];

        self.cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *cancel = [MOPTools fat_currentLanguageIsEn] ? @"Cancel" : @"取消";
        self.cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [self.cancelButton setTitle:cancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[MOPTools fat_dynamicColorWithLightHexString:@"#222222" darkHexString:@"#D0D0D0"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelButton];
        self.cancelButton.frame = CGRectMake(0, self.contentView.frame.size.height - kFinoSafeAreaBottom - 56, self.contentView.frame.size.width, 56 );
        [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 58.5, frame.size.width, 107);
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 165.5, self.collectionView.frame.size.width, 0.5)];
        line2.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#E0E0E0" darkHexString:@"#2E2E2E"];
        [self.contentView addSubview:line2];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6.0, 6.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        self.shareView.frame = CGRectMake(52.5, self.contentView.frame.origin.y - 400 , 270 , 380);
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(278.5,  self.shareView.frame.origin.y + 12, 36, 36)];
        [saveButton addTarget:self action:@selector(saveOnClick) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setImage:[UIImage imageNamed:@"share_download"] forState:UIControlStateNormal];
        [self addSubview:saveButton];
        [self p_addNotifications];
    }
    return self;
}

+ (instancetype)viewWithData:(NSDictionary *)data {
    MopShareView *view = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.dataDic = data;
    return view;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.qrCodeImageView.image = [MOPTools makeQRCodeForString:dataDic[@"shareUrl"]];
    });
    self.titleLabel.text = dataDic[@"miniAppName"];
    self.descLabel.text = dataDic[@"miniAppDesc"];
}

- (void)saveOnClick {
    // 把view生成图片并保存
    UIImage *image = [MOPTools snapshotWithView:self.shareView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        // 出错
        [self fatMakeToast:@"保存成功" duration:1.5 position:CSToastPositionCenter];
    } else {
        [self fatMakeToast:[NSString stringWithFormat:@"保存失败，%@", error.description] duration:1.5 position:CSToastPositionCenter];

    }
}


- (void)p_addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat currentWidth = self.frame.size.width;
    if (screenWidth != currentWidth) {
        [self removeFromSuperview];
    }
}

- (void)show {
    self.appletImageView.image = self.image;
    if (self.superview) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.size.height);
        self.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismiss];
}

#pragma mark colletionview ------------------------------
static NSString *cellID = @"cellid";
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOPshareBottomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.imageButton setImage:[UIImage imageNamed:self.dataArray[indexPath.row][@"lightImage"]] forState:UIControlStateNormal];
    cell.label.text = self.dataArray[indexPath.row][@"title"];
    cell.type = self.dataArray[indexPath.row][@"type"];
    cell.delegate = self;
    return cell;
}

- (void)iconBtnDidClick:(MOPshareBottomViewCell *)cell {
    if (self.didSelcetTypeBlock) {
        NSString *typeString = cell.type;
        self.didSelcetTypeBlock(typeString);
    }
    [self dismiss];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelcetTypeBlock) {
        NSString *typeString = self.dataArray[indexPath.row][@"type"];
        self.didSelcetTypeBlock(typeString);
    }
    [self dismiss];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(66, self.collectionView.frame.size.height);
}

- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self layout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MOPshareBottomViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#F0F0F0" darkHexString:@"#1A1A1A"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;;
}
@end

@implementation MOPshareBottomViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#F0F0F0" darkHexString:@"#1A1A1A"];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18, 20, 48, 48)];
        button.backgroundColor = [MOPTools fat_dynamicColorWithLightHexString:@"#FFFFFF " darkHexString:@"#2C2C2C"];
        [self.contentView addSubview:button];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6;
        UIImage *highBgImage = [UIImage fat_imageWithColor:[MOPTools fat_dynamicColorWithLightHexString:@"#D7D7D7 " darkHexString:@"#4A4A4A"]];
        [button setBackgroundImage:highBgImage forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.imageButton = button;
        // self.label = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-50)/2, 65, frame.size.width, 30)];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(18, 75, 48, 12)];
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

- (void)iconBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconBtnDidClick:)]) {
        [self.delegate iconBtnDidClick:self];
    }
}

@end

