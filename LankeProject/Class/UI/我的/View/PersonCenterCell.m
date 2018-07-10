//
//  PersonCenterCell.m
//  LankeProject
//
//  Created by Justin on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "PersonCenterCell.h"

@interface PersonCenterCell()

@property (nonatomic, strong) UIImageView *lineImage;
@property (nonatomic, strong) UIImageView *rightImage;
@end

@implementation PersonCenterCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.leftImage = [[UIImageView alloc] init];
        [self addSubview:self.leftImage];
        
        [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.offset(5);
        }];
        
        self.titleLB = [[UILabel alloc] init];
        self.titleLB.font = BM_FONTSIZE(15.0);
        self.titleLB.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self addSubview:self.titleLB];
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.leftImage.mas_right).offset(20);
        }];

        self.lineImage = [[UIImageView alloc] init];
        self.lineImage.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        [self addSubview:self.lineImage];
        
        [self.lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLB.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.height.offset(1);
        }];
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        rightImage.image = [UIImage imageNamed:@"UserCenter-RightArrow"];
        [self addSubview:rightImage];
        self.rightImage=rightImage;
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.offset(7);
            make.height.offset(15);
        }];
        
        UIImageView *redImage = [[UIImageView alloc] init];
        redImage.image = [UIImage imageWithColor:BM_RED];
        redImage.layer.masksToBounds=YES;
        redImage.layer.cornerRadius=6/2;
        [self addSubview:redImage];
        self.redImage=redImage;
        [redImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLB.mas_right).offset(3);
            make.top.mas_equalTo(self.titleLB.mas_top).offset(3);
            make.width.and.height.mas_equalTo(6);
        }];

    }
    return self;
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.leftImage.image = [UIImage imageWithColor:dataSource[@"color"]];
    self.titleLB.text = dataSource[@"title"];
}


@end
