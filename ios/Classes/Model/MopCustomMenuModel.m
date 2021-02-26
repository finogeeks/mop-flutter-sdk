//
//  MopCustomMenuModel.m
//  mop
//
//  Created by Lin on 2021/2/26.
//

#import "MopCustomMenuModel.h"

@implementation MopCustomMenuModel

@synthesize menuId, menuIconImage, menuTitle, menuType;

- (id)copyWithZone:(NSZone *)zone
{
    MopCustomMenuModel *model = [[MopCustomMenuModel allocWithZone:zone] init];
    model.menuId = self.menuId;
    model.menuIconImage = self.menuIconImage;
    model.menuTitle = self.menuTitle;
    model.menuType = self.menuType;
    return model;
}

@end
