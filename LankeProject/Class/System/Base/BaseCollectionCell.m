//
//  BaseCollectionCell.m
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell

+ (CGFloat)getCellHightWithDataSource:(id)dataSource
{
    return 100.0f;

}
+ (CGFloat)getCellHeight
{
    return 100.0f;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = selectedBGView;
        self.selectionStyle=UICollectionViewCellSelectionStyleNone;
    }
    
    return  self;
}
-(void)setSelectionStyle:(UICollectionViewCellSelectionStyle)selectionStyle
{
    _selectionStyle=selectionStyle;
    if (selectionStyle==UICollectionViewCellSelectionStyleGray)
    {
         self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    }
    else
    {
        self.selectedBackgroundView.backgroundColor = BM_CLEAR;
    }
}

-(void)setSelected:(BOOL)selected
{
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.data=dataSource;
}

@end
