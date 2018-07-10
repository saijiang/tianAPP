//
//  DiningBootomCell.h
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "BaseTableViewCell.h"

@class CustomBtn;

@interface DiningBootomCell : BaseTableViewCell

@property (nonatomic,strong)CustomBtn *oneBtn;
@property (nonatomic,strong)CustomBtn *twoBtn;
@property (nonatomic,strong)CustomBtn *threeBtn;

@end


@interface CustomBtn : UIButton

@property (nonatomic,strong)LocalhostImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;

-(void)loadCustomDataWithData:(id)dataSource;

@end
