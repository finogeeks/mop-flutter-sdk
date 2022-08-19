//
//  MOP_showBotomSheetModel.m
//  mop
//
//  Created by 胡健辉 on 2020/12/11.
//

#import "MOP_showBotomSheetModel.h"
#import "MopPlugin.h"


@implementation MOP_showBotomSheetModel

- (void)setupApiWithSuccess:(void (^)(NSDictionary<NSString *,id> * _Nonnull))success failure:(void (^)(id _Nullable))failure cancel:(void (^)(void))cancel {
    NSLog(@"showBotomSheetModel");
    MOP_shareBottomView *view = [MOP_shareBottomView view];
    [view show];
    [view setDidSelcetTypeBlock:^(NSInteger type) {
        FlutterMethodChannel *channel = [[MopPlugin instance] shareMethodChannel];
        [channel invokeMethod:@"shareApi:doShare" arguments:@{@"type":@(type)} result:^(id  _Nullable result) {

        }];
    }];
    success(@{});
}

@end


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

@interface MOP_shareBottomView ()<UICollectionViewDelegate, UICollectionViewDataSource>
/**
 整个内容的View
 */
@property (nonatomic, strong) UIView *contentView;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation MOP_shareBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = @[@(0)];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 150 - kFinoSafeAreaBottom, self.frame.size.width, 150 + kFinoSafeAreaBottom)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelButton];
        self.cancelButton.frame = CGRectMake(0, self.contentView.frame.size.height - kFinoSafeAreaBottom - 50, self.contentView.frame.size.width, 50);
        [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cancelButton.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.cancelButton addSubview:line];
        
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, frame.size.width, 100);

    }
    return self;
}

+ (instancetype)view {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)show {
    if (self.superview) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
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
    [self dismiss];
}

#pragma mark colletionview ------------------------------
static NSString *cellID = @"cellid";
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOP_shareBottomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.type = [self.dataArray[indexPath.row] intValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelcetTypeBlock) {
        MOP_shareBottomViewCell *cell = (MOP_shareBottomViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.didSelcetTypeBlock(cell.type);
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
    return CGSizeMake(self.collectionView.frame.size.width / self.dataArray.count, self.collectionView.frame.size.height);
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
        [_collectionView registerClass:[MOP_shareBottomViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;;
}
@end

@implementation MOP_shareBottomViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [UIImageView new];
        self.imageView.frame = CGRectMake((frame.size.width-50)/2, 10, 50, 50);
        [self.contentView addSubview:self.imageView];
        
        // self.label = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-50)/2, 65, frame.size.width, 30)];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(25, 65, frame.size.width-50, 30)];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (_type == 0) {
        self.label.text = @"微信好友";
        self.imageView.image = [UIImage imageNamed:@"turkey_share_wechat"];
    }
}
@end
