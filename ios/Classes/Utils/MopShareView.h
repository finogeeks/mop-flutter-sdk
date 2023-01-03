//
//  MopShareView.h
//  mop
//
//  Created by 王兆耀 on 2023/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MOPshareBottomViewTypeBlock)(NSString *type);

@interface MopShareView : UIView
@property(nonatomic, copy) MOPshareBottomViewTypeBlock didSelcetTypeBlock;
@property (nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSDictionary *dataDic;
+ (instancetype)viewWithData:(NSDictionary *)data;
- (void)show;
- (void)dismiss;
@end

@interface MOPshareBottomViewCell : UICollectionViewCell
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;


@end

NS_ASSUME_NONNULL_END
