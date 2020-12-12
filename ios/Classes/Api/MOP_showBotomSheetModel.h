//
//  MOP_showBotomSheetModel.h
//  mop
//
//  Created by 胡健辉 on 2020/12/11.
//

#import <UIKit/UIKit.h>
#import "MOPBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOP_showBotomSheetModel : MOPBaseApi
@property(nonatomic, strong) NSString *appId;

@end


typedef void (^MOP_shareBottomViewTypeBlock)(NSInteger type);

@interface MOP_shareBottomView : UIView
@property(nonatomic, copy) MOP_shareBottomViewTypeBlock didSelcetTypeBlock;

+ (instancetype)view;
- (void)show;
- (void)dismiss;

@end

@interface MOP_shareBottomViewCell : UICollectionViewCell
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;


@end
NS_ASSUME_NONNULL_END
