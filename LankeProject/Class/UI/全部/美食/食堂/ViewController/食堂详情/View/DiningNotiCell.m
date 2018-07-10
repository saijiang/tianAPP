//
//  DiningNotiCell.m
//  LankeProject
//
//  Created by 符丹 on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DiningNotiCell.h"

@implementation DiningNotiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.news=[[RestauraNewsView alloc]init];
        [self.contentView addSubview:self.news];
        [self.news mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)loadCellWithDataSource:(id)dataSource
{
    [self.news loadTitleWithTitle:dataSource];
}

@end
