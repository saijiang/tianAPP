//
//  HealthCollectionCell.m
//  LankeProject
//
//  Created by itman on 17/1/18.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HealthCollectionCell.h"

@implementation HealthCollectionCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    HealthCollectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HealthCollectionCell"];
    if (!cell)
    {
        cell=[[HealthCollectionCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HealthCollectionCell"];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = BM_WHITE;
        
        self.BigTitle = [UnityLHClass masonryLabel:@"**" font:16.0 color:[UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:1]];
        [self addSubview:self.BigTitle];
        
        self.timeLB = [UnityLHClass masonryLabel:@"****-**-**" font:13.0 color:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self addSubview:self.timeLB];
        
        self.headImage = [[UIImageView alloc] init];
        self.headImage.clipsToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headImage.image = [UIImage imageNamed:@"Health-headImage"];
        [self addSubview:self.headImage];
        
        
        self.imageIcon = [[UIImageView alloc] init];
        self.imageIcon.image = [UIImage imageNamed:@"Health-videoicon"];
        [self.headImage addSubview:self.imageIcon];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.BigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.mas_equalTo(20);
        make.right.offset(-10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.BigTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.right.offset(-10);
    }];
    

    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.BigTitle.mas_left);
        make.top.mas_equalTo(self.timeLB.mas_bottom).offset(10);
        make.right.offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImage.mas_centerX);
        make.centerY.mas_equalTo(self.headImage.mas_centerY);
        make.width.and.height.offset(30);
    }];
}

- (void)loadCellWithDataSource:(id)dataSource
{
    
    self.BigTitle.text = [NSString stringWithFormat:@"%@",dataSource[@"title"]];
    self.timeLB.text =[[dataSource[@"createDate"] componentsSeparatedByString:@" "] firstObject];
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSource[@"healthImageList"]]];
    [self.headImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Health-headImage"]];
    self.imageIcon.hidden = [dataSource[@"type"] isEqualToString:@"01"];
}

@end
