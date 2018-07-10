//
//  RestaurantHeaderView.h
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantHeaderView : UIView

@property (nonatomic ,copy) void (^bRestaurantIndex)(NSString *type);

- (void) config:(id)data;
@end


@interface RestaurantHeaderViewCell : BaseCollectionCell

@property(nonatomic,strong)LocalhostImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *eName;

-(void)loadMallCellWithDataSource:(id)dataSource;


@end
