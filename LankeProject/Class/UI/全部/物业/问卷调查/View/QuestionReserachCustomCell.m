//
//  QuestionReserachCustomCell.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "QuestionReserachCustomCell.h"
#import "QuestionInfoModel.h"

@implementation QuestionReserachCustomCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QuestionReserachCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionReserachCustomCell"];
    if (!cell)
    {
        cell = [[QuestionReserachCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionReserachCustomCell"];
    }
    return cell;
}

-(void)createCell
{
    self.chooseBtn = [[LeftImageBtn alloc]init];
    self.chooseBtn.userInteractionEnabled=NO;
    [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
    [self.chooseBtn setTitle:@"" forState:UIControlStateNormal];
    [self.chooseBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1] forState:UIControlStateNormal];
    [self.chooseBtn setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
    [self.contentView addSubview:self.chooseBtn];
    self.chooseBtn.titleLabel.numberOfLines=0;
    self.chooseBtn.titleLabel.font=BM_FONTSIZE(14.0);
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

-(void)loadCellWithDataSource:(QuestionInfoModel*)dataSource
{
    NSString *chooseTitle=dataSource.optionsName;
    self.chooseBtn.selected=dataSource.seleted;
    [self.chooseBtn setTitle:chooseTitle forState:UIControlStateNormal];
}

@end
