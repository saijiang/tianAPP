//
//  MallHeaderView.h
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "RestaurantHeaderView.h"
#import "ModuleCell.h"


@interface MallHeaderView : UICollectionReusableView<ModuleCellDelegate,CommonHeaderViewDelegate>

@property(nonatomic,strong)CommonHeaderView *bannerView;
@property(nonatomic,strong)ModuleCell *classificationView;

//加载广告位数据
-(void)configureBannerViewWithImageData:(id)dataSource;
//加载分类数据
-(void)loadClassificationViewWithDataSource:(id)dataSource;

+(float)getMallHeaderViewHightWithDataSource:(NSArray *)dataSource;

@end
