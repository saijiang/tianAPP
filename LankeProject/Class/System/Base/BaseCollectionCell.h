//
//  BaseCollectionCell.h
//  LankeProject
//
//  Created by Justin on 16/6/2.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICollectionViewCellSelectionStyle)
{
    UICollectionViewCellSelectionStyleNone,
    UICollectionViewCellSelectionStyleGray,
};


@interface BaseCollectionCell : UICollectionViewCell

+ (CGFloat)getCellHightWithDataSource:(id)dataSource;
+ (CGFloat)getCellHeight;

@property(nonatomic,strong)id data;
@property(nonatomic,assign)UICollectionViewCellSelectionStyle selectionStyle;

-(void)loadCellWithDataSource:(id)dataSource;

@end
