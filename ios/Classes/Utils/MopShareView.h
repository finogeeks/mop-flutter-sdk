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
@property (nonatomic, copy) MOPshareBottomViewTypeBlock didSelcetTypeBlock;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDictionary *dataDic;
+ (instancetype)viewWithData:(NSDictionary *)data;
- (void)show;
- (void)dismiss;
@end


@class MOPshareBottomViewCell;

@protocol MOPCellClickDelegate <NSObject>
- (void)iconBtnDidClick:(MOPshareBottomViewCell *)cell;
@end

@interface MOPshareBottomViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) id<MOPCellClickDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
