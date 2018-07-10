//
//  SymptomCell.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "SymptomCell.h"

@implementation SymptomCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.name=[UnityLHClass masonryLabel:@"零食" font:14.0 color:BM_BLACK];
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        UIView *lineView=[[UIView alloc]init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name.mas_left);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
       
    }
    return self;
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.name.text=dataSource[@"symptomsClassName"];
}

+(NSString*)cellIdentifier
{
    return @"SymptomCell";
}



@end
