//
//  MallGoodsCell.h
//  LankeProject
//
//  Created by itman on 17/1/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface MallSearchGoodsCell : BaseCollectionCell

@property(nonatomic,strong)NetworkImageView *goodIcon;
@property(nonatomic,strong)UILabel *goodName;



+(NSString*)cellIdentifier;

@end
