//
//  MopCustomMenuModel.m
//  mop
//
//  Created by Lin on 2021/2/26.
//

#import "MopCustomMenuModel.h"

@implementation MopCustomMenuModel

- (id)copyWithZone:(NSZone *)zone
{
    MopCustomMenuModel *model = [[MopCustomMenuModel allocWithZone:zone] init];
    model.menuId = self.menuId;
    model.menuIconImage = self.menuIconImage;
    model.menuIconDarkImage = self.menuIconDarkImage;
    model.menuTitle = self.menuTitle;
    model.menuType = self.menuType;
    model.menuIconUrl = self.menuIconUrl;
    model.menuDarkIconUrl = self.menuDarkIconUrl;
    return model;
}

@end
