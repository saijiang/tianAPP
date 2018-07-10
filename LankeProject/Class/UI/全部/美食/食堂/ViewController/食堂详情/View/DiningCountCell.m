//
//  DiningCountCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningCountCell.h"

@implementation DiningCountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.titleLab = [UnityLHClass masonryLabel:@"食堂可容纳人数：" font:14.0 color:BM_Color_GrayColor];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
        
        self.contentLab = [UnityLHClass masonryLabel:@"200人" font:14.0 color:BM_Color_BlackColor];
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

//-(void)loadCellWithDataSource:(id)dataSource
//{
//    self.titleLab
//    
//    self.contentLab.text = dataSource;
//}

@end
